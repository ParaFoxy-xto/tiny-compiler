#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "codegen.h"
#include "tac.h"

#define PC 7
#define AC 0
#define AC1 1

typedef struct VarMapping {
    char* name;
    int mem_loc;
    struct VarMapping* next;
} VarMapping;

typedef struct BackpatchNode {
    long file_pos_to_patch; 
    int jump_instr_loc;      
    struct BackpatchNode* next;
} BackpatchNode;

typedef struct LabelMapping {
    char* name;
    int is_defined;          
    int instr_loc;           
    BackpatchNode* patch_list_head; 
    struct LabelMapping* next;
} LabelMapping;

static VarMapping* var_map_head = NULL;
static LabelMapping* label_map_head = NULL;

static int is_constante(const char* s) {
    if (s == NULL || *s == '\0') {
        return 0;
    }
    char* end;
    strtol(s, &end, 10);
    return *end == '\0';
}

static int get_or_create_var(const char* name, int* data_mem_offset) {
    VarMapping* current = var_map_head;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current->mem_loc;
        }
        current = current->next;
    }
    VarMapping* new_var = (VarMapping*)malloc(sizeof(VarMapping));
    new_var->name = strdup(name);
    new_var->mem_loc = (*data_mem_offset)++;
    new_var->next = var_map_head;
    var_map_head = new_var;
    return new_var->mem_loc;
}

static LabelMapping* get_or_create_label_map(const char* name) {
    LabelMapping* current = label_map_head;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    LabelMapping* new_label = (LabelMapping*)malloc(sizeof(LabelMapping));
    new_label->name = strdup(name);
    new_label->is_defined = 0;
    new_label->instr_loc = -1;
    new_label->patch_list_head = NULL;
    new_label->next = label_map_head;
    label_map_head = new_label;
    return new_label;
}

static void free_mappings() {
    VarMapping* current_var = var_map_head;
    while(current_var) {
        VarMapping* to_free = current_var;
        current_var = current_var->next;
        free(to_free->name);
        free(to_free);
    }
    var_map_head = NULL;

    LabelMapping* current_label = label_map_head;
    while(current_label) {
        LabelMapping* to_free_label = current_label;
        current_label = current_label->next;

        BackpatchNode* current_patch = to_free_label->patch_list_head;
        while(current_patch) {
            BackpatchNode* to_free_patch = current_patch;
            current_patch = current_patch->next;
            free(to_free_patch);
        }
        free(to_free_label->name);
        free(to_free_label);
    }
    label_map_head = NULL;
}

static void tm_load_operand(FILE* out_file, int reg, const char* operand, int* instruction_loc, int* data_loc) {
    if (is_constante(operand)) {
        fprintf(out_file, "%3d:  LDC %d,%s(0)\n", (*instruction_loc)++, reg, operand);
    } else {
        int mem_loc = get_or_create_var(operand, data_loc);
        fprintf(out_file, "%3d:  LD  %d,%d(5)\n", (*instruction_loc)++, reg, mem_loc);
    }
}

int tm_generate_code(const char* output_filename) {
    FILE* out_file = fopen(output_filename, "w");
    if (!out_file) {
        perror("Falha ao abrir arquivo.");
        return -1;
    }
	
    // --- Standard Prelude ---
    fprintf(out_file, "* Tiny Machine Code Generated on %s\n", __DATE__);
    fprintf(out_file, "* Standard prelude\n");
    fprintf(out_file, "  0:  LD 6,0(0)\t* Load constant 0\n");
    fprintf(out_file, "  1:  ST %d,0(0)\t* Clear location 0 in data memory\n", AC);
    fprintf(out_file, "* End of standard prelude\n");

    int instruction_loc = 2;
    int data_loc = 0;
    Tac* current_tac = tac_list_head;

    while (current_tac != NULL) {
        int loc_res;
        LabelMapping* label_map;
        switch (current_tac->op) {
            case TAC_OP_ASSIGN:
                tm_load_operand(out_file, AC, current_tac->arg1, &instruction_loc, &data_loc);
                loc_res = get_or_create_var(current_tac->res, &data_loc);
                fprintf(out_file, "%3d:  ST  %d,%d(5)\n", instruction_loc++, AC, loc_res);
                break;
            case TAC_OP_ADD:
            case TAC_OP_SUB:
                tm_load_operand(out_file, AC, current_tac->arg1, &instruction_loc, &data_loc);
                tm_load_operand(out_file, AC1, current_tac->arg2, &instruction_loc, &data_loc);
                const char* op_str = (current_tac->op == TAC_OP_ADD) ? "ADD" : "SUB";
                fprintf(out_file, "%3d:  %s  %d,%d,%d\n", instruction_loc++, op_str, AC, AC, AC1);
                loc_res = get_or_create_var(current_tac->res, &data_loc);
                fprintf(out_file, "%3d:  ST  %d,%d(5)\n", instruction_loc++, AC, loc_res);
                break;
            case TAC_OP_LT:
            case TAC_OP_GT:
            case TAC_OP_EQ:
            case TAC_OP_NEQ:
                tm_load_operand(out_file, AC, current_tac->arg1, &instruction_loc, &data_loc);
                tm_load_operand(out_file, AC1, current_tac->arg2, &instruction_loc, &data_loc);
                fprintf(out_file, "%3d:  SUB %d,%d,%d\n", instruction_loc++, AC, AC, AC1);

                const char* jmp_op_rel;
                switch(current_tac->op) {
                    case TAC_OP_LT:  jmp_op_rel = "JLT"; break;
                    case TAC_OP_GT:  jmp_op_rel = "JGT"; break;
                    case TAC_OP_EQ:  jmp_op_rel = "JEQ"; break;
                    case TAC_OP_NEQ: jmp_op_rel = "JNE"; break;
                    default:         jmp_op_rel = "JMP";
                }

                fprintf(out_file, "%3d:  %s %d,%d(%d)\n", instruction_loc++, jmp_op_rel, AC, 2, PC);
                fprintf(out_file, "%3d:  LDC %d,0(0)\n", instruction_loc++, AC);
                fprintf(out_file, "%3d:  LDA %d,%d(%d)\n", instruction_loc++, PC, 1, PC);
                fprintf(out_file, "%3d:  LDC %d,1(0)\n", instruction_loc++, AC);

                loc_res = get_or_create_var(current_tac->res, &data_loc);
                fprintf(out_file, "%3d:  ST  %d,%d(5)\n", instruction_loc++, AC, loc_res);
                break;
            case TAC_OP_LABEL:
                label_map = get_or_create_label_map(current_tac->res);
                if (label_map->is_defined) {
                    fprintf(stderr, "CodeGen Error: Duplicate label definition '%s'\n", label_map->name);
                } else {
                    label_map->is_defined = 1;
                    label_map->instr_loc = instruction_loc;
                    long current_file_pos = ftell(out_file);
                    BackpatchNode* patch = label_map->patch_list_head;
                    while (patch) {
                        fseek(out_file, patch->file_pos_to_patch, SEEK_SET);
			int offset = label_map->instr_loc - (patch->jump_instr_loc + 1);

		  	char patch_str[13];
			snprintf(patch_str, sizeof(patch_str), "%d(%d)", offset, PC);
    			fprintf(out_file, "%-12s", patch_str);

			fflush(out_file);
                        patch = patch->next;
                    }
                    fseek(out_file, current_file_pos, SEEK_SET);
                }
                break;
            case TAC_OP_GOTO:
            case TAC_OP_IF_FALSE:
                if (current_tac->op == TAC_OP_IF_FALSE) {
                    tm_load_operand(out_file, AC, current_tac->arg1, &instruction_loc, &data_loc);
                }
                label_map = get_or_create_label_map(current_tac->res);
                const char* jmp_op = (current_tac->op == TAC_OP_GOTO) ? "LDA" : "JEQ";
                int reg = (current_tac->op == TAC_OP_GOTO) ? PC : AC;

                if (label_map->is_defined) {
                    int offset = label_map->instr_loc - (instruction_loc + 1);
                    fprintf(out_file, "%3d:  %s  %d,%d(%d)\n", instruction_loc++, jmp_op, reg, offset, PC);
                } else {
                    fprintf(out_file, "%3d:  %s  %d,", instruction_loc, jmp_op, reg);
                    long patch_pos = ftell(out_file);
		    fprintf(out_file, "%-12s\n", "(________)"); 

		    // atualiza head daquela label. obs: aqui no while nao passar de um registro
                    BackpatchNode* new_patch = (BackpatchNode*)malloc(sizeof(BackpatchNode));
                    new_patch->file_pos_to_patch = patch_pos;
                    new_patch->jump_instr_loc = instruction_loc;
                    new_patch->next = label_map->patch_list_head;
                    label_map->patch_list_head = new_patch;
                    instruction_loc++;
                }
                break;

            default:
                fprintf(stderr, "CodeGen Error: Unknown TAC opcode %d\n", current_tac->op);
                break;
        }
        current_tac = current_tac->next;
    }

    fprintf(out_file, "* End of program\n");
    fprintf(out_file, "%3d: HALT 0,0,0\n", instruction_loc);

    fclose(out_file);
    free_mappings();
    printf("Codigo para TM gerado com sucesso. Saida: %s\n", output_filename);
    return 0;
}

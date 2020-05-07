import numpy as np
cimport numpy as np

from pyrossgeo.__defs__ cimport node, cnode, transporter, DTYPE_t
from pyrossgeo.__defs__ import DTYPE

#ctypedef void (*SIM_EVENT)(Simulation cg, int step_i, DTYPE_t t, DTYPE_t dt, DTYPE_t[:] X_state, DTYPE_t[:] dX_state)
#cdef void SIM_EVENT_NULL(Simulation cg, int step_i, DTYPE_t t, DTYPE_t dt, DTYPE_t[:] X_state, DTYPE_t[:] dX_state)

cdef class Simulation:
    cdef readonly int age_groups
    cdef readonly int model_dim
    cdef readonly int max_node_index

    cdef node* nodes
    cdef int nodes_num

    cdef cnode* cnodes
    cdef int cnodes_num

    cdef int state_size
    cdef int node_states_len # The slice of X_states which only comprises nodes

    cdef readonly object state_mappings

    cdef readonly dict storage # Persistent storage that will be used for events

    # Model
    cdef int** class_infections
    cdef int* class_infections_num
    cdef int[:] infection_classes_indices
    cdef int infection_classes_num
    cdef int** linear_terms
    cdef int* linear_terms_num
    cdef np.ndarray contact_matrices
    cdef readonly dict contact_matrices_key_to_index
    cdef object _lambdas_arr
    cdef np.ndarray _lambdas
    cdef object _Is_arr
    cdef np.ndarray _Is
    cdef object _Ns_arr
    cdef np.ndarray _Ns

    # Transport
    cdef transporter* Ts # Going into commuterverses
    cdef int Ts_num
    cdef transporter* cTs # Going out from commuterverses
    cdef int cTs_num

    # Used for lambda calculation
    cdef int*** nodes_at_j
    cdef int** nodes_at_j_len

    # Used for tau calculation
    cdef int*** cnodes_into_k
    cdef int** cnodes_into_k_len

    # Transport profile
    cdef DTYPE_t transport_profile_integrated
    cdef DTYPE_t transport_profile_integrated_r
    cdef DTYPE_t transport_profile_m
    cdef DTYPE_t transport_profile_c
    cdef DTYPE_t transport_profile_c_r

    #cdef csimulate(self, DTYPE_t[:] X_state, DTYPE_t t_start, DTYPE_t t_end, object _dts, int steps_per_save=*,
    #                            str out_file=*, int steps_per_print=*, bint only_save_nodes=*,
    #                            int steps_per_event=*,object event_function=*,
    #                            int steps_per_cevent=*, SIM_EVENT cevent_function=*)

    cpdef get_contact_matrix_keys(self)
    cpdef get_contact_matrix(self, str cmat_key)
    cpdef set_contact_matrix(self, str cmat_key, np.ndarray cmat)

    cpdef stop_commuting(self, bint s)
    cpdef bint is_commuting_stopped(self)

from cymem.cymem cimport Pool

from libc.stdint cimport uint32_t
from libcpp.pair cimport pair
from libcpp.queue cimport priority_queue
from libcpp.vector cimport vector

from thinc.learner cimport weight_t
from thinc.learner cimport class_t


ctypedef pair[size_t, size_t] Candidate
ctypedef pair[weight_t, Candidate] Entry
ctypedef priority_queue[Entry] Queue


ctypedef int (*trans_func_t)(void* dest, void* src, class_t clas, void* x) except -1

ctypedef void* (*init_func_t)(Pool mem, int n, void* extra_args) except NULL

ctypedef int (*finish_func_t)(void* state, void* extra_args) except -1


cdef struct _State:
    void* content
    class_t* hist
    weight_t score
    int loss
    int i
    int t
    bint is_done


cdef class Beam:
    cdef Pool mem
    cdef class_t nr_class
    cdef class_t width
    cdef class_t size
    cdef Queue q
    cdef _State* _parents
    cdef _State* _states

    cdef int _fill(self, weight_t** scores, bint** is_valid) except -1

    cdef void* at(self, int i)
    cdef int initialize(self, init_func_t init_func, int n, void* extra_args) except -1
    cdef int advance(self, weight_t** scores, bint** is_valid, int** costs,
                     trans_func_t transition_func, void* extra_args) except -1
    cdef int check_done(self, finish_func_t finish_func, void* extra_args) except -1
 


cdef class MaxViolation:
    cdef Pool mem
    cdef int cost
    cdef weight_t delta
    cdef class_t n
    cdef readonly list p_hist
    cdef readonly list g_hist

    cpdef int check(self, Beam pred, Beam gold) except -1

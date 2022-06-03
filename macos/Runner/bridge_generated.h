#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_Vector3 {
  double x;
  double y;
  double z;
} wire_Vector3;

typedef struct WireSyncReturnStruct {
  uint8_t *ptr;
  int32_t len;
  bool success;
} WireSyncReturnStruct;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

void wire_node_handle(int64_t port_);

void wire_publish_twist(int64_t port_,
                        struct wire_uint_8_list *topic,
                        struct wire_Vector3 *linear,
                        struct wire_Vector3 *angular);

struct wire_Vector3 *new_box_autoadd_vector_3(void);

struct wire_uint_8_list *new_uint_8_list(int32_t len);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

void store_dart_post_cobject(DartPostCObjectFnType ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_node_handle);
    dummy_var ^= ((int64_t) (void*) wire_publish_twist);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_vector_3);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturnStruct);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}
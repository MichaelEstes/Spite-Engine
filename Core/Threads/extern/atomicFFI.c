#pragma once

#include <stdatomic.h>

#define _export __declspec(dllexport)

// Compile Windows 
// cl /c /std:c11 /experimental:c11atomics atomicFFI.c
// LIB.EXE atomicFFI.obj
// LINK.EXE /DLL atomicFFI.obj

_export void __cdecl atomic_store_i8(volatile atomic_char* obj, int8_t value, memory_order order)
{
	atomic_store_explicit(obj, value, order);
}
_export void __cdecl atomic_store_i16(volatile atomic_short* obj, int16_t value, memory_order order)
{
	atomic_store_explicit(obj, value, order);
}
_export void __cdecl atomic_store_i32(volatile atomic_int* obj, int32_t value, memory_order order)
{
	atomic_store_explicit(obj, value, order);
}
_export void __cdecl atomic_store_i64(volatile atomic_llong* obj, int64_t value, memory_order order)
{
	atomic_store_explicit(obj, value, order);
}
_export void __cdecl atomic_store_u8(volatile atomic_uchar* obj, uint8_t value, memory_order order)
{
	atomic_store_explicit(obj, value, order);
}
_export void __cdecl atomic_store_u16(volatile atomic_ushort* obj, uint16_t value, memory_order order)
{
	atomic_store_explicit(obj, value, order);
}
_export void __cdecl atomic_store_u32(volatile atomic_uint* obj, uint32_t value, memory_order order)
{
	atomic_store_explicit(obj, value, order);
}
_export void __cdecl atomic_store_u64(volatile atomic_ullong* obj, uint64_t value, memory_order order)
{
	atomic_store_explicit(obj, value, order);
}
_export void __cdecl atomic_store_ptr(volatile atomic_uintptr_t* obj, atomic_uintptr_t value, memory_order order)
{
	atomic_store_explicit(obj, value, order);
}

_export int8_t __cdecl atomic_load_i8(volatile atomic_char* obj, memory_order order)
{
	return atomic_load_explicit(obj, order);
}
_export int16_t __cdecl atomic_load_i16(volatile atomic_short* obj, memory_order order)
{
	return atomic_load_explicit(obj, order);
}
_export int32_t __cdecl atomic_load_i32(volatile atomic_int* obj, memory_order order)
{
	return atomic_load_explicit(obj, order);
}
_export int64_t __cdecl atomic_load_i64(volatile atomic_llong* obj, memory_order order)
{
	return atomic_load_explicit(obj, order);
}
_export uint8_t __cdecl atomic_load_u8(volatile atomic_uchar* obj, memory_order order)
{
	return atomic_load_explicit(obj, order);
}
_export uint16_t __cdecl atomic_load_u16(volatile atomic_ushort* obj, memory_order order)
{
	return atomic_load_explicit(obj, order);
}
_export uint32_t __cdecl atomic_load_u32(volatile atomic_uint* obj, memory_order order)
{
	return atomic_load_explicit(obj, order);
}
_export uint64_t __cdecl atomic_load_u64(volatile atomic_ullong* obj, memory_order order)
{
	return atomic_load_explicit(obj, order);
}
_export atomic_uintptr_t __cdecl atomic_load_ptr(volatile atomic_uintptr_t* obj, memory_order order)
{
	return atomic_load_explicit(obj, order);
}

_export int8_t __cdecl atomic_exchange_i8(volatile atomic_char* obj, int8_t value, memory_order order)
{
	return atomic_exchange_explicit(obj, value, order);
}
_export int16_t __cdecl atomic_exchange_i16(volatile atomic_short* obj, int16_t value, memory_order order)
{
	return atomic_exchange_explicit(obj, value, order);
}
_export int32_t __cdecl atomic_exchange_i32(volatile atomic_int* obj, int32_t value, memory_order order)
{
	return atomic_exchange_explicit(obj, value, order);
}
_export int64_t __cdecl atomic_exchange_i64(volatile atomic_llong* obj, int64_t value, memory_order order)
{
	return atomic_exchange_explicit(obj, value, order);
}
_export uint8_t __cdecl atomic_exchange_u8(volatile atomic_uchar* obj, uint8_t value, memory_order order)
{
	return atomic_exchange_explicit(obj, value, order);
}
_export uint16_t __cdecl atomic_exchange_u16(volatile atomic_ushort* obj, uint16_t value, memory_order order)
{
	return atomic_exchange_explicit(obj, value, order);
}
_export uint32_t __cdecl atomic_exchange_u32(volatile atomic_uint* obj, uint32_t value, memory_order order)
{
	return atomic_exchange_explicit(obj, value, order);
}
_export uint64_t __cdecl atomic_exchange_u64(volatile atomic_ullong* obj, uint64_t value, memory_order order)
{
	return atomic_exchange_explicit(obj, value, order);
}
_export atomic_uintptr_t __cdecl atomic_exchange_ptr(volatile atomic_uintptr_t* obj, atomic_uintptr_t value, memory_order order)
{
	return atomic_exchange_explicit(obj, value, order);
}

_export _Bool __cdecl atomic_compare_exchange_strong_i8(volatile atomic_char* obj, int8_t* expected, int8_t value, memory_order succeed, memory_order fail)
{
	return atomic_compare_exchange_strong_explicit(obj, expected, value, succeed, fail);
}
_export _Bool __cdecl atomic_compare_exchange_strong_i16(volatile atomic_short* obj, int16_t* expected, int16_t value, memory_order succeed, memory_order fail)
{
	return atomic_compare_exchange_strong_explicit(obj, expected, value, succeed, fail);
}
_export _Bool __cdecl atomic_compare_exchange_strong_i32(volatile atomic_int* obj, int32_t* expected, int32_t value, memory_order succeed, memory_order fail)
{
	return atomic_compare_exchange_strong_explicit(obj, expected, value, succeed, fail);
}
_export _Bool __cdecl atomic_compare_exchange_strong_i64(volatile atomic_llong* obj, int64_t* expected, int64_t value, memory_order succeed, memory_order fail)
{
	return atomic_compare_exchange_strong_explicit(obj, expected, value, succeed, fail);
}
_export _Bool __cdecl atomic_compare_exchange_strong_u8(volatile atomic_uchar* obj, uint8_t* expected, uint8_t value, memory_order succeed, memory_order fail)
{
	return atomic_compare_exchange_strong_explicit(obj, expected, value, succeed, fail);
}
_export _Bool __cdecl atomic_compare_exchange_strong_u16(volatile atomic_ushort* obj, uint16_t* expected, uint16_t value, memory_order succeed, memory_order fail)
{
	return atomic_compare_exchange_strong_explicit(obj, expected, value, succeed, fail);
}
_export _Bool __cdecl atomic_compare_exchange_strong_u32(volatile atomic_uint* obj, uint32_t* expected, uint32_t value, memory_order succeed, memory_order fail)
{
	return atomic_compare_exchange_strong_explicit(obj, expected, value, succeed, fail);
}
_export _Bool __cdecl atomic_compare_exchange_strong_u64(volatile atomic_ullong* obj, uint64_t* expected, uint64_t value, memory_order succeed, memory_order fail)
{
	return atomic_compare_exchange_strong_explicit(obj, expected, value, succeed, fail);
}
_export _Bool __cdecl atomic_compare_exchange_strong_ptr(volatile atomic_uintptr_t* obj, atomic_uintptr_t* expected, atomic_uintptr_t value, memory_order succeed, memory_order fail)
{
	return atomic_compare_exchange_strong_explicit(obj, expected, value, succeed, fail);
}

_export int8_t __cdecl atomic_fetch_add_i8(volatile atomic_char* obj, int8_t value, memory_order order)
{
	return atomic_fetch_add_explicit(obj, value, order);
}
_export int16_t __cdecl atomic_fetch_add_i16(volatile atomic_short* obj, int16_t value, memory_order order)
{
	return atomic_fetch_add_explicit(obj, value, order);
}
_export int32_t __cdecl atomic_fetch_add_i32(volatile atomic_int* obj, int32_t value, memory_order order)
{
	return atomic_fetch_add_explicit(obj, value, order);
}
_export int64_t __cdecl atomic_fetch_add_i64(volatile atomic_llong* obj, int64_t value, memory_order order)
{
	return atomic_fetch_add_explicit(obj, value, order);
}
_export uint8_t __cdecl atomic_fetch_add_u8(volatile atomic_uchar* obj, uint8_t value, memory_order order)
{
	return atomic_fetch_add_explicit(obj, value, order);
}
_export uint16_t __cdecl atomic_fetch_add_u16(volatile atomic_ushort* obj, uint16_t value, memory_order order)
{
	return atomic_fetch_add_explicit(obj, value, order);
}
_export uint32_t __cdecl atomic_fetch_add_u32(volatile atomic_uint* obj, uint32_t value, memory_order order)
{
	return atomic_fetch_add_explicit(obj, value, order);
}
_export uint64_t __cdecl atomic_fetch_add_u64(volatile atomic_ullong* obj, uint64_t value, memory_order order)
{
	return atomic_fetch_add_explicit(obj, value, order);
}
_export atomic_uintptr_t __cdecl atomic_fetch_add_ptr(volatile atomic_uintptr_t* obj, atomic_uintptr_t value, memory_order order)
{
	return atomic_fetch_add_explicit(obj, value, order);
}

_export int8_t __cdecl atomic_fetch_sub_i8(volatile atomic_char* obj, int8_t value, memory_order order)
{
	return atomic_fetch_sub_explicit(obj, value, order);
}
_export int16_t __cdecl atomic_fetch_sub_i16(volatile atomic_short* obj, int16_t value, memory_order order)
{
	return atomic_fetch_sub_explicit(obj, value, order);
}
_export int32_t __cdecl atomic_fetch_sub_i32(volatile atomic_int* obj, int32_t value, memory_order order)
{
	return atomic_fetch_sub_explicit(obj, value, order);
}
_export int64_t __cdecl atomic_fetch_sub_i64(volatile atomic_llong* obj, int64_t value, memory_order order)
{
	return atomic_fetch_sub_explicit(obj, value, order);
}
_export uint8_t __cdecl atomic_fetch_sub_u8(volatile atomic_uchar* obj, uint8_t value, memory_order order)
{
	return atomic_fetch_sub_explicit(obj, value, order);
}
_export uint16_t __cdecl atomic_fetch_sub_u16(volatile atomic_ushort* obj, uint16_t value, memory_order order)
{
	return atomic_fetch_sub_explicit(obj, value, order);
}
_export uint32_t __cdecl atomic_fetch_sub_u32(volatile atomic_uint* obj, uint32_t value, memory_order order)
{
	return atomic_fetch_sub_explicit(obj, value, order);
}
_export uint64_t __cdecl atomic_fetch_sub_u64(volatile atomic_ullong* obj, uint64_t value, memory_order order)
{
	return atomic_fetch_sub_explicit(obj, value, order);
}
_export atomic_uintptr_t __cdecl atomic_fetch_sub_ptr(volatile atomic_uintptr_t* obj, atomic_uintptr_t value, memory_order order)
{
	return atomic_fetch_sub_explicit(obj, value, order);
}

_export int8_t __cdecl atomic_fetch_or_i8(volatile atomic_char* obj, int8_t value, memory_order order)
{
	return atomic_fetch_or_explicit(obj, value, order);
}
_export int16_t __cdecl atomic_fetch_or_i16(volatile atomic_short* obj, int16_t value, memory_order order)
{
	return atomic_fetch_or_explicit(obj, value, order);
}
_export int32_t __cdecl atomic_fetch_or_i32(volatile atomic_int* obj, int32_t value, memory_order order)
{
	return atomic_fetch_or_explicit(obj, value, order);
}
_export int64_t __cdecl atomic_fetch_or_i64(volatile atomic_llong* obj, int64_t value, memory_order order)
{
	return atomic_fetch_or_explicit(obj, value, order);
}
_export uint8_t __cdecl atomic_fetch_or_u8(volatile atomic_uchar* obj, uint8_t value, memory_order order)
{
	return atomic_fetch_or_explicit(obj, value, order);
}
_export uint16_t __cdecl atomic_fetch_or_u16(volatile atomic_ushort* obj, uint16_t value, memory_order order)
{
	return atomic_fetch_or_explicit(obj, value, order);
}
_export uint32_t __cdecl atomic_fetch_or_u32(volatile atomic_uint* obj, uint32_t value, memory_order order)
{
	return atomic_fetch_or_explicit(obj, value, order);
}
_export uint64_t __cdecl atomic_fetch_or_u64(volatile atomic_ullong* obj, uint64_t value, memory_order order)
{
	return atomic_fetch_or_explicit(obj, value, order);
}
_export atomic_uintptr_t __cdecl atomic_fetch_or_ptr(volatile atomic_uintptr_t* obj, atomic_uintptr_t value, memory_order order)
{
	return atomic_fetch_or_explicit(obj, value, order);
}

_export int8_t __cdecl atomic_fetch_xor_i8(volatile atomic_char* obj, int8_t value, memory_order order)
{
	return atomic_fetch_xor_explicit(obj, value, order);
}
_export int16_t __cdecl atomic_fetch_xor_i16(volatile atomic_short* obj, int16_t value, memory_order order)
{
	return atomic_fetch_xor_explicit(obj, value, order);
}
_export int32_t __cdecl atomic_fetch_xor_i32(volatile atomic_int* obj, int32_t value, memory_order order)
{
	return atomic_fetch_xor_explicit(obj, value, order);
}
_export int64_t __cdecl atomic_fetch_xor_i64(volatile atomic_llong* obj, int64_t value, memory_order order)
{
	return atomic_fetch_xor_explicit(obj, value, order);
}
_export uint8_t __cdecl atomic_fetch_xor_u8(volatile atomic_uchar* obj, uint8_t value, memory_order order)
{
	return atomic_fetch_xor_explicit(obj, value, order);
}
_export uint16_t __cdecl atomic_fetch_xor_u16(volatile atomic_ushort* obj, uint16_t value, memory_order order)
{
	return atomic_fetch_xor_explicit(obj, value, order);
}
_export uint32_t __cdecl atomic_fetch_xor_u32(volatile atomic_uint* obj, uint32_t value, memory_order order)
{
	return atomic_fetch_xor_explicit(obj, value, order);
}
_export uint64_t __cdecl atomic_fetch_xor_u64(volatile atomic_ullong* obj, uint64_t value, memory_order order)
{
	return atomic_fetch_xor_explicit(obj, value, order);
}
_export atomic_uintptr_t __cdecl atomic_fetch_xor_ptr(volatile atomic_uintptr_t* obj, atomic_uintptr_t value, memory_order order)
{
	return atomic_fetch_xor_explicit(obj, value, order);
}

_export int8_t __cdecl atomic_fetch_and_i8(volatile atomic_char* obj, int8_t value, memory_order order)
{
	return atomic_fetch_and_explicit(obj, value, order);
}
_export int16_t __cdecl atomic_fetch_and_i16(volatile atomic_short* obj, int16_t value, memory_order order)
{
	return atomic_fetch_and_explicit(obj, value, order);
}
_export int32_t __cdecl atomic_fetch_and_i32(volatile atomic_int* obj, int32_t value, memory_order order)
{
	return atomic_fetch_and_explicit(obj, value, order);
}
_export int64_t __cdecl atomic_fetch_and_i64(volatile atomic_llong* obj, int64_t value, memory_order order)
{
	return atomic_fetch_and_explicit(obj, value, order);
}
_export uint8_t __cdecl atomic_fetch_and_u8(volatile atomic_uchar* obj, uint8_t value, memory_order order)
{
	return atomic_fetch_and_explicit(obj, value, order);
}
_export uint16_t __cdecl atomic_fetch_and_u16(volatile atomic_ushort* obj, uint16_t value, memory_order order)
{
	return atomic_fetch_and_explicit(obj, value, order);
}
_export uint32_t __cdecl atomic_fetch_and_u32(volatile atomic_uint* obj, uint32_t value, memory_order order)
{
	return atomic_fetch_and_explicit(obj, value, order);
}
_export uint64_t __cdecl atomic_fetch_and_u64(volatile atomic_ullong* obj, uint64_t value, memory_order order)
{
	return atomic_fetch_and_explicit(obj, value, order);
}
_export atomic_uintptr_t __cdecl atomic_fetch_and_ptr(volatile atomic_uintptr_t* obj, atomic_uintptr_t value, memory_order order)
{
	return atomic_fetch_and_explicit(obj, value, order);
}

_export void __cdecl atomic_init_i8(volatile atomic_char* obj, int8_t value)
{
	atomic_init(obj, value);
}
_export void __cdecl atomic_init_i16(volatile atomic_short* obj, int16_t value)
{
	atomic_init(obj, value);
}
_export void __cdecl atomic_init_i32(volatile atomic_int* obj, int32_t value)
{
	atomic_init(obj, value);
}
_export void __cdecl atomic_init_i64(volatile atomic_llong* obj, int64_t value)
{
	atomic_init(obj, value);
}
_export void __cdecl atomic_init_u8(volatile atomic_uchar* obj, uint8_t value)
{
	atomic_init(obj, value);
}
_export void __cdecl atomic_init_u16(volatile atomic_ushort* obj, uint16_t value)
{
	atomic_init(obj, value);
}
_export void __cdecl atomic_init_u32(volatile atomic_uint* obj, uint32_t value)
{
	atomic_init(obj, value);
}
_export void __cdecl atomic_init_u64(volatile atomic_ullong* obj, uint64_t value)
{
	atomic_init(obj, value);
}
_export void __cdecl atomic_init_ptr(volatile atomic_uintptr_t* obj, atomic_uintptr_t value)
{
	atomic_init(obj, value);
}
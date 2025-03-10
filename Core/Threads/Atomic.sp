package Atomic

extern
{
	#link linux "./extern/atomicFFI";
	#link windows "./extern/atomicFFI";

	void atomic_store_i8 (obj: *byte,   value: byte,   order: MemoryOrder);
	void atomic_store_i16(obj: *int16,  value: int16,  order: MemoryOrder);
	void atomic_store_i32(obj: *int32,  value: int32,  order: MemoryOrder);
	void atomic_store_i64(obj: *int64,  value: int64,  order: MemoryOrder);
	void atomic_store_u8 (obj: *ubyte,  value: ubyte,  order: MemoryOrder);
	void atomic_store_u16(obj: *uint16, value: uint16, order: MemoryOrder);
	void atomic_store_u32(obj: *uint32, value: uint32, order: MemoryOrder);
	void atomic_store_u64(obj: *uint64, value: uint64, order: MemoryOrder);
	void atomic_store_ptr(obj: *uint,   value: uint,   order: MemoryOrder);

	byte atomic_load_i8   (obj: *byte,   order: MemoryOrder);
	int16 atomic_load_i16 (obj: *int16,  order: MemoryOrder);
	int32 atomic_load_i32 (obj: *int32,  order: MemoryOrder);
	int64 atomic_load_i64 (obj: *int64,  order: MemoryOrder);
	ubyte atomic_load_u8  (obj: *ubyte,  order: MemoryOrder);
	uint16 atomic_load_u16(obj: *uint16, order: MemoryOrder);
	uint32 atomic_load_u32(obj: *uint32, order: MemoryOrder);
	uint64 atomic_load_u64(obj: *uint64, order: MemoryOrder);
	uint atomic_load_ptr  (obj: *uint,   order: MemoryOrder);

	byte atomic_exchange_i8   (obj: *byte,   value: byte,   order: MemoryOrder);
	int16 atomic_exchange_i16 (obj: *int16,  value: int16,  order: MemoryOrder);
	int32 atomic_exchange_i32 (obj: *int32,  value: int32,  order: MemoryOrder);
	int64 atomic_exchange_i64 (obj: *int64,  value: int64,  order: MemoryOrder);
	ubyte atomic_exchange_u8  (obj: *ubyte,  value: ubyte,  order: MemoryOrder);
	uint16 atomic_exchange_u16(obj: *uint16, value: uint16, order: MemoryOrder);
	uint32 atomic_exchange_u32(obj: *uint32, value: uint32, order: MemoryOrder);
	uint64 atomic_exchange_u64(obj: *uint64, value: uint64, order: MemoryOrder);
	uint atomic_exchange_ptr  (obj: *uint,   value: uint,   order: MemoryOrder);

	bool atomic_compare_exchange_strong_i8 (obj: *byte,   expected: *byte,   value: byte,   succeed: MemoryOrder, fail: MemoryOrder);
	bool atomic_compare_exchange_strong_i16(obj: *int16,  expected: *int16,  value: int16,  succeed: MemoryOrder, fail: MemoryOrder);
	bool atomic_compare_exchange_strong_i32(obj: *int32,  expected: *int32,  value: int32,  succeed: MemoryOrder, fail: MemoryOrder);
	bool atomic_compare_exchange_strong_i64(obj: *int64,  expected: *int64,  value: int64,  succeed: MemoryOrder, fail: MemoryOrder);
	bool atomic_compare_exchange_strong_u8 (obj: *ubyte,  expected: *ubyte,  value: ubyte,  succeed: MemoryOrder, fail: MemoryOrder);
	bool atomic_compare_exchange_strong_u16(obj: *uint16, expected: *uint16, value: uint16, succeed: MemoryOrder, fail: MemoryOrder);
	bool atomic_compare_exchange_strong_u32(obj: *uint32, expected: *uint32, value: uint32, succeed: MemoryOrder, fail: MemoryOrder);
	bool atomic_compare_exchange_strong_u64(obj: *uint64, expected: *uint64, value: uint64, succeed: MemoryOrder, fail: MemoryOrder);
	bool atomic_compare_exchange_strong_ptr(obj: *uint,   expected: *uint,   value: uint,   succeed: MemoryOrder, fail: MemoryOrder);
	
	byte atomic_fetch_add_i8   (obj: *byte,   value: byte,   order: MemoryOrder);
	int16 atomic_fetch_add_i16 (obj: *int16,  value: int16,  order: MemoryOrder);
	int32 atomic_fetch_add_i32 (obj: *int32,  value: int32,  order: MemoryOrder);
	int64 atomic_fetch_add_i64 (obj: *int64,  value: int64,  order: MemoryOrder);
	ubyte atomic_fetch_add_u8  (obj: *ubyte,  value: ubyte,  order: MemoryOrder);
	uint16 atomic_fetch_add_u16(obj: *uint16, value: uint16, order: MemoryOrder);
	uint32 atomic_fetch_add_u32(obj: *uint32, value: uint32, order: MemoryOrder);
	uint64 atomic_fetch_add_u64(obj: *uint64, value: uint64, order: MemoryOrder);
	uint atomic_fetch_add_ptr  (obj: *uint,   value: uint,   order: MemoryOrder);
	
	byte atomic_fetch_sub_i8   (obj: *byte,   value: byte,   order: MemoryOrder);
	int16 atomic_fetch_sub_i16 (obj: *int16,  value: int16,  order: MemoryOrder);
	int32 atomic_fetch_sub_i32 (obj: *int32,  value: int32,  order: MemoryOrder);
	int64 atomic_fetch_sub_i64 (obj: *int64,  value: int64,  order: MemoryOrder);
	ubyte atomic_fetch_sub_u8  (obj: *ubyte,  value: ubyte,  order: MemoryOrder);
	uint16 atomic_fetch_sub_u16(obj: *uint16, value: uint16, order: MemoryOrder);
	uint32 atomic_fetch_sub_u32(obj: *uint32, value: uint32, order: MemoryOrder);
	uint64 atomic_fetch_sub_u64(obj: *uint64, value: uint64, order: MemoryOrder);
	uint atomic_fetch_sub_ptr  (obj: *uint,   value: uint,   order: MemoryOrder);
	
	byte atomic_fetch_or_i8   (obj: *byte,   value: byte,   order: MemoryOrder);
	int16 atomic_fetch_or_i16 (obj: *int16,  value: int16,  order: MemoryOrder);
	int32 atomic_fetch_or_i32 (obj: *int32,  value: int32,  order: MemoryOrder);
	int64 atomic_fetch_or_i64 (obj: *int64,  value: int64,  order: MemoryOrder);
	ubyte atomic_fetch_or_u8  (obj: *ubyte,  value: ubyte,  order: MemoryOrder);
	uint16 atomic_fetch_or_u16(obj: *uint16, value: uint16, order: MemoryOrder);
	uint32 atomic_fetch_or_u32(obj: *uint32, value: uint32, order: MemoryOrder);
	uint64 atomic_fetch_or_u64(obj: *uint64, value: uint64, order: MemoryOrder);
	uint atomic_fetch_or_ptr  (obj: *uint,   value: uint,   order: MemoryOrder);
	
	byte atomic_fetch_xor_i8   (obj: *byte,   value: byte,   order: MemoryOrder);
	int16 atomic_fetch_xor_i16 (obj: *int16,  value: int16,  order: MemoryOrder);
	int32 atomic_fetch_xor_i32 (obj: *int32,  value: int32,  order: MemoryOrder);
	int64 atomic_fetch_xor_i64 (obj: *int64,  value: int64,  order: MemoryOrder);
	ubyte atomic_fetch_xor_u8  (obj: *ubyte,  value: ubyte,  order: MemoryOrder);
	uint16 atomic_fetch_xor_u16(obj: *uint16, value: uint16, order: MemoryOrder);
	uint32 atomic_fetch_xor_u32(obj: *uint32, value: uint32, order: MemoryOrder);
	uint64 atomic_fetch_xor_u64(obj: *uint64, value: uint64, order: MemoryOrder);
	uint atomic_fetch_xor_ptr  (obj: *uint,   value: uint,   order: MemoryOrder);
	
	byte atomic_fetch_and_i8   (obj: *byte,   value: byte,   order: MemoryOrder);
	int16 atomic_fetch_and_i16 (obj: *int16,  value: int16,  order: MemoryOrder);
	int32 atomic_fetch_and_i32 (obj: *int32,  value: int32,  order: MemoryOrder);
	int64 atomic_fetch_and_i64 (obj: *int64,  value: int64,  order: MemoryOrder);
	ubyte atomic_fetch_and_u8  (obj: *ubyte,  value: ubyte,  order: MemoryOrder);
	uint16 atomic_fetch_and_u16(obj: *uint16, value: uint16, order: MemoryOrder);
	uint32 atomic_fetch_and_u32(obj: *uint32, value: uint32, order: MemoryOrder);
	uint64 atomic_fetch_and_u64(obj: *uint64, value: uint64, order: MemoryOrder);
	uint atomic_fetch_and_ptr  (obj: *uint,   value: uint,   order: MemoryOrder);
	
	void atomic_init_i8 (obj: *byte,   value: byte);
	void atomic_init_i16(obj: *int16,  value: int16);
	void atomic_init_i32(obj: *int32,  value: int32);
	void atomic_init_i64(obj: *int64,  value: int64);
	void atomic_init_u8 (obj: *ubyte,  value: ubyte);
	void atomic_init_u16(obj: *uint16, value: uint16);
	void atomic_init_u32(obj: *uint32, value: uint32);
	void atomic_init_u64(obj: *uint64, value: uint64);
	void atomic_init_ptr(obj: *uint,   value: uint);
}

enum MemoryOrder: int32 
{
	Relaxed,
	Consume,
	Acquire,
	Release,
	AcquireRelease,
	Sequential 
}

state Atomic<Type>
{
	value: Type
}

_CheckValidAtomicType(type: *_Type)
{
	assert type.IsInteger() || type.IsPointer(), "Not a valid type for atomic operations";
}

Atomic::(value: Type)
{
	init := #compile ::void(*Type, Type) {
		type := #typeof Type;
		_CheckValidAtomicType(type);
		typeKind := type.kind;
		typeUnion := type.type;
		
		if(typeKind == _TypeKind.PrimitiveType)
		{
			switch (typeUnion.primitive.primitiveKind)
			{
				case (_PrimitiveKind.Bool) return atomic_init_u8;
				case (_PrimitiveKind.Byte) 
				{
					if (typeUnion.primitive.isSigned) return atomic_init_i8;
					return atomic_init_u8;
				}
				case (_PrimitiveKind.I16)
				{
					if (typeUnion.primitive.isSigned) return atomic_init_i16;
					return atomic_init_u16;
				}
				case (_PrimitiveKind.I32)
				{
					if (typeUnion.primitive.isSigned) return atomic_init_i32;
					return atomic_init_u32;
				}
				case (_PrimitiveKind.I64) continue;
				case (_PrimitiveKind.Int)
				{
					if (typeUnion.primitive.isSigned) return atomic_init_i64;
					return atomic_init_u64;
				}
			}
		}
		
		return atomic_init_ptr;
	}

	init(this.value@, value);
}

Atomic::Store(value: Type, order: MemoryOrder = MemoryOrder.Sequential)
{
	store := #compile ::void(*Type, Type, MemoryOrder) {
		type := #typeof Type;
		_CheckValidAtomicType(type);
		typeKind := type.kind;
		typeUnion := type.type;
		
		if(typeKind == _TypeKind.PrimitiveType)
		{
			switch (typeUnion.primitive.primitiveKind)
			{
				case (_PrimitiveKind.Bool) return atomic_store_u8;
				case (_PrimitiveKind.Byte) 
				{
					if (typeUnion.primitive.isSigned) return atomic_store_i8;
					return atomic_store_u8;
				}
				case (_PrimitiveKind.I16)
				{
					if (typeUnion.primitive.isSigned) return atomic_store_i16;
					return atomic_store_u16;
				}
				case (_PrimitiveKind.I32)
				{
					if (typeUnion.primitive.isSigned) return atomic_store_i32;
					return atomic_store_u32;
				}
				case (_PrimitiveKind.I64) continue;
				case (_PrimitiveKind.Int)
				{
					if (typeUnion.primitive.isSigned) return atomic_store_i64;
					return atomic_store_u64;
				}
			}
		}
		
		return atomic_store_ptr;
	}

	store(this.value@, value, order);
}

Type Atomic::Load(order: MemoryOrder = MemoryOrder.Sequential)
{
	load := #compile ::Type(*Type, MemoryOrder) {
		type := #typeof Type;
		_CheckValidAtomicType(type);
		typeKind := type.kind;
		typeUnion := type.type;
		
		if(typeKind == _TypeKind.PrimitiveType)
		{
			switch (typeUnion.primitive.primitiveKind)
			{
				case (_PrimitiveKind.Bool) return atomic_load_u8;
				case (_PrimitiveKind.Byte) 
				{
					if (typeUnion.primitive.isSigned) return atomic_load_i8;
					return atomic_load_u8;
				}
				case (_PrimitiveKind.I16)
				{
					if (typeUnion.primitive.isSigned) return atomic_load_i16;
					return atomic_load_u16;
				}
				case (_PrimitiveKind.I32)
				{
					if (typeUnion.primitive.isSigned) return atomic_load_i32;
					return atomic_load_u32;
				}
				case (_PrimitiveKind.I64) continue;
				case (_PrimitiveKind.Int)
				{
					if (typeUnion.primitive.isSigned) return atomic_load_i64;
					return atomic_load_u64;
				}
			}
		}
		
		return atomic_load_ptr;
	}

	return load(this.value@, order);
}

Type Atomic::Exchange(value: Type, order: MemoryOrder = MemoryOrder.Sequential)
{
	exchange := #compile ::Type(*Type, Type, MemoryOrder) {
		type := #typeof Type;
		_CheckValidAtomicType(type);
		typeKind := type.kind;
		typeUnion := type.type;
		
		if(typeKind == _TypeKind.PrimitiveType)
		{
			switch (typeUnion.primitive.primitiveKind)
			{
				case (_PrimitiveKind.Bool) return atomic_exchange_u8;
				case (_PrimitiveKind.Byte) 
				{
					if (typeUnion.primitive.isSigned) return atomic_exchange_i8;
					return atomic_exchange_u8;
				}
				case (_PrimitiveKind.I16)
				{
					if (typeUnion.primitive.isSigned) return atomic_exchange_i16;
					return atomic_exchange_u16;
				}
				case (_PrimitiveKind.I32)
				{
					if (typeUnion.primitive.isSigned) return atomic_exchange_i32;
					return atomic_exchange_u32;
				}
				case (_PrimitiveKind.I64) continue;
				case (_PrimitiveKind.Int)
				{
					if (typeUnion.primitive.isSigned) return atomic_exchange_i64;
					return atomic_exchange_u64;
				}
			}
		}
		
		return atomic_exchange_ptr;
	}

	return exchange(this.value@, value, order);
}

bool Atomic::CompareExchange(expected: *byte, value: byte, succeed: MemoryOrder = MemoryOrder.Sequential, fail: MemoryOrder = MemoryOrder.Sequential)
{
	cmpexch := #compile ::bool(*Type, *Type, Type, MemoryOrder, MemoryOrder) {
		type := #typeof Type;
		_CheckValidAtomicType(type);
		typeKind := type.kind;
		typeUnion := type.type;
		
		if(typeKind == _TypeKind.PrimitiveType)
		{
			switch (typeUnion.primitive.primitiveKind)
			{
				case (_PrimitiveKind.Bool) return atomic_compare_exchange_strong_u8;
				case (_PrimitiveKind.Byte) 
				{
					if (typeUnion.primitive.isSigned) return atomic_compare_exchange_strong_i8;
					return atomic_compare_exchange_strong_u8;
				}
				case (_PrimitiveKind.I16)
				{
					if (typeUnion.primitive.isSigned) return atomic_compare_exchange_strong_i16;
					return atomic_compare_exchange_strong_u16;
				}
				case (_PrimitiveKind.I32)
				{
					if (typeUnion.primitive.isSigned) return atomic_compare_exchange_strong_i32;
					return atomic_compare_exchange_strong_u32;
				}
				case (_PrimitiveKind.I64) continue;
				case (_PrimitiveKind.Int)
				{
					if (typeUnion.primitive.isSigned) return atomic_compare_exchange_strong_i64;
					return atomic_compare_exchange_strong_u64;
				}
			}
		}
		
		return atomic_compare_exchange_strong_ptr;
	}

	return cmpexch(this.value@, expected, value, succeed, fail);
}

Type Atomic::Add(value: Type, order: MemoryOrder = MemoryOrder.Sequential)
{
	add := #compile ::Type(*Type, Type, MemoryOrder) {
		type := #typeof Type;
		_CheckValidAtomicType(type);
		typeKind := type.kind;
		typeUnion := type.type;
		
		if(typeKind == _TypeKind.PrimitiveType)
		{
			switch (typeUnion.primitive.primitiveKind)
			{
				case (_PrimitiveKind.Bool) return atomic_fetch_add_u8;
				case (_PrimitiveKind.Byte) 
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_add_i8;
					return atomic_fetch_add_u8;
				}
				case (_PrimitiveKind.I16)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_add_i16;
					return atomic_fetch_add_u16;
				}
				case (_PrimitiveKind.I32)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_add_i32;
					return atomic_fetch_add_u32;
				}
				case (_PrimitiveKind.I64) continue;
				case (_PrimitiveKind.Int)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_add_i64;
					return atomic_fetch_add_u64;
				}
			}
		}
		
		return atomic_fetch_add_ptr;
	}

	return add(this.value@, value, order);
}

Type Atomic::Sub(value: Type, order: MemoryOrder = MemoryOrder.Sequential)
{
	sub := #compile ::Type(*Type, Type, MemoryOrder) {
		type := #typeof Type;
		_CheckValidAtomicType(type);
		typeKind := type.kind;
		typeUnion := type.type;
		
		if(typeKind == _TypeKind.PrimitiveType)
		{
			switch (typeUnion.primitive.primitiveKind)
			{
				case (_PrimitiveKind.Bool) return atomic_fetch_sub_u8;
				case (_PrimitiveKind.Byte) 
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_sub_i8;
					return atomic_fetch_sub_u8;
				}
				case (_PrimitiveKind.I16)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_sub_i16;
					return atomic_fetch_sub_u16;
				}
				case (_PrimitiveKind.I32)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_sub_i32;
					return atomic_fetch_sub_u32;
				}
				case (_PrimitiveKind.I64) continue;
				case (_PrimitiveKind.Int)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_sub_i64;
					return atomic_fetch_sub_u64;
				}
			}
		}
		
		return atomic_fetch_sub_ptr;
	}

	return sub(this.value@, value, order);
}

Type Atomic::Or(value: Type, order: MemoryOrder = MemoryOrder.Sequential)
{
	or := #compile ::Type(*Type, Type, MemoryOrder) {
		type := #typeof Type;
		_CheckValidAtomicType(type);
		typeKind := type.kind;
		typeUnion := type.type;
		
		if(typeKind == _TypeKind.PrimitiveType)
		{
			switch (typeUnion.primitive.primitiveKind)
			{
				case (_PrimitiveKind.Bool) return atomic_fetch_or_u8;
				case (_PrimitiveKind.Byte) 
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_or_i8;
					return atomic_fetch_or_u8;
				}
				case (_PrimitiveKind.I16)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_or_i16;
					return atomic_fetch_or_u16;
				}
				case (_PrimitiveKind.I32)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_or_i32;
					return atomic_fetch_or_u32;
				}
				case (_PrimitiveKind.I64) continue;
				case (_PrimitiveKind.Int)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_or_i64;
					return atomic_fetch_or_u64;
				}
			}
		}
		
		return atomic_fetch_or_ptr;
	}

	return or(this.value@, value, order);
}

Type Atomic::XOr(value: Type, order: MemoryOrder = MemoryOrder.Sequential)
{
	xor := #compile ::Type(*Type, Type, MemoryOrder) {
		type := #typeof Type;
		_CheckValidAtomicType(type);
		typeKind := type.kind;
		typeUnion := type.type;
		
		if(typeKind == _TypeKind.PrimitiveType)
		{
			switch (typeUnion.primitive.primitiveKind)
			{
				case (_PrimitiveKind.Bool) return atomic_fetch_xor_u8;
				case (_PrimitiveKind.Byte) 
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_xor_i8;
					return atomic_fetch_xor_u8;
				}
				case (_PrimitiveKind.I16)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_xor_i16;
					return atomic_fetch_xor_u16;
				}
				case (_PrimitiveKind.I32)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_xor_i32;
					return atomic_fetch_xor_u32;
				}
				case (_PrimitiveKind.I64) continue;
				case (_PrimitiveKind.Int)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_xor_i64;
					return atomic_fetch_xor_u64;
				}
			}
		}
		
		return atomic_fetch_xor_ptr;
	}

	return xor(this.value@, value, order);
}

Type Atomic::And(value: Type, order: MemoryOrder = MemoryOrder.Sequential)
{
	and := #compile ::Type(*Type, Type, MemoryOrder) {
		type := #typeof Type;
		_CheckValidAtomicType(type);
		typeKind := type.kind;
		typeUnion := type.type;
		
		if(typeKind == _TypeKind.PrimitiveType)
		{
			switch (typeUnion.primitive.primitiveKind)
			{
				case (_PrimitiveKind.Bool) return atomic_fetch_and_u8;
				case (_PrimitiveKind.Byte) 
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_and_i8;
					return atomic_fetch_and_u8;
				}
				case (_PrimitiveKind.I16)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_and_i16;
					return atomic_fetch_and_u16;
				}
				case (_PrimitiveKind.I32)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_and_i32;
					return atomic_fetch_and_u32;
				}
				case (_PrimitiveKind.I64) continue;
				case (_PrimitiveKind.Int)
				{
					if (typeUnion.primitive.isSigned) return atomic_fetch_and_i64;
					return atomic_fetch_and_u64;
				}
			}
		}
		
		return atomic_fetch_and_ptr;
	}

	return and(this.value@, value, order);
}

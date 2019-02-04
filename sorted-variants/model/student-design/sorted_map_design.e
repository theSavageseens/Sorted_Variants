note
	description: "Summary description for {SORTED_MAP_DESIGN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SORTED_MAP_DESIGN [K -> COMPARABLE, V -> ANY]

inherit
	SORTED_MAP_ADT[K,V]

feature -- model
	model: FUN [K, V]
			-- abstraction function
		do
			create Result.make_from_array (as_array)
		end

feature{NONE} -- attributes
	implementation: SORTED_ADT [K,V]
			-- inefficient but abstract implementation of sorted map
		deferred
		end

feature{NONE} -- constructors

	make_empty
			-- creates a sorted map without any elements
		do
			implementation.make_empty
		end

	make_from_array (array: ARRAY [TUPLE [key: K; val: V]])
			-- creates a sorted map with the elements of the `array'
		do
			implementation.make_from_array (array)
		end

	make_from_sorted_map (map: SORTED_MAP_ADT [K, V])
			-- creates a sorted map from `other'
		do
			make_from_array(map.as_array)
		end

feature -- commands

	put (val: V; key: K) --(key: K; val: V)
			-- puts an element of `key' and `value' into map
			-- behaves like `extend' if `key' does not exist
			-- otherwise behaves like `update'
			-- NOTE: This method follows the convention of `val'/`key'
		do
			if
				implementation.has (key)
			then
				replace(key, val)
			else
				extend(key, val)
			end
		end

	extend (key: K; val: V)
			-- inserts an element of `key' and `value' into map
		do
			implementation.extend ([key, val])
		end

	remove (key: K)
			-- removes an element whose value is `key' from the map
		do
			implementation.remove (key)
		end

	prune (val: V; i: INTEGER)
			-- removes `i'th occurrence of `val' from the map
			-- demanding version
		do
			remove (occurrences (val)[i])
		end

	prune_all (val: V)
			-- removes all occurences of `val' from the map
			-- does nothing if element does not exist
		do
			across occurrences (val) as k
			loop
				remove (k.item)
			end
		end

	replace (key: K; val: V)
			-- replaces `value' for a given `key'
		do
			remove(key)
			extend(key, val)
		end

	replace_key (old_key, new_key: K)
			-- replaces `old_key' with `new_key' for an element
		local
			l_val: V
		do
			l_val := implementation [old_key]
			remove (old_key)
			extend (new_key, l_val)
		end

	wipe_out
			--makes an existing map empty
		do
			implementation.wipe_out
		end

	merge (other: SORTED_MAP_ADT[K,V])
			-- merges `Current' map with `other' map
		do
			across other as o
			loop
				extend(o.item.key, o.item.value)
			end
		end

feature -- queries

	item alias "[]" (key: K): V assign put
			--returns the value associated with `key'
		do
			Result := implementation [key]
		end

	as_array: ARRAY [TUPLE [key: K; value: V]]
			-- returns an array of tuples sorted by key
		do
			create Result.make_empty
			across implementation.as_array as ar loop Result.force (ar.item, Result.count + 1) end
			Result.compare_objects
		end

	sorted_keys: ARRAY [K]
			-- returns a sorted array of keys
		do
			create Result.make_empty
			across implementation.as_array as ar loop Result.force(ar.item.key,Result.count+1) end
			Result.compare_objects
		end

	values: ARRAY [V]
			--returns an array of values sorted by key
		do
			create Result.make_empty
			across implementation.as_array as ar loop Result.force(ar.item.value,Result.count+1) end
			Result.compare_objects
		end

	has (key: K): BOOLEAN
			-- returns whether `key' exists in the map
		do
			Result := implementation.has (key)
		end

	has_value(val: V): BOOLEAN
			-- returns whether `val' exists in the map
		do
			Result := values.has (val)
		end

	element (key: K): detachable TUPLE [key: K; val:V]
			-- returns an element of the map (i.e. a tuple [`key', value])
			-- associated with `key'
		do
			if has (key) then
				Result := [key, implementation [key]]
			end
		end

	count: INTEGER
			--returns number of elements in the map
		do
			Result := implementation.count
		end

	is_empty: BOOLEAN
			-- returns whether the map is empty
		do
			Result := implementation.count = 0
		end

	min: TUPLE [key: K; val: V]
			--returns the pairing with the smallest key in the map
		do
			Result := as_array [1]
		end

	max: TUPLE [key: K; val: V]
			--returns the element with the largest key in the map
		do
			Result := as_array [implementation.count]
		end

	occurrences (val: V): ARRAY [K]
			-- returns a sorted array of keys who have `val' as their value
			-- may return an empty array
		do
			create Result.make_empty
			across implementation.as_array as node loop if
				node.item.item.val ~ val
			then
				Result.force(node.item.item.key ,Result.count+1) end
			end
		end
end

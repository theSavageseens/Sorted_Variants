note
	description: "Summary description for {SORTED_MAP_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SORTED_MAP_CURSOR [K, V]

inherit
	ITERATION_CURSOR [TUPLE [K ,V]]

create
	make

feature {NONE} -- constructors
	make (a: ARRAY[TUPLE[K, V]])
	do
		create array.make_from_array(a)
		index := array.lower
	end

feature --attributes
	array : ARRAY[TUPLE[K, V]]
	index : INTEGER

feature -- Access

	item: TUPLE[key : K; value : V]
			-- Item at current cursor position.

		do
		   Result := array[index]
		end

feature -- Status report	

	after: BOOLEAN
			-- Are there no more items to iterate over?
		do
			Result := index > array.upper
		end

feature -- Cursor movement

	forth
			-- Move to next position.
		do
			index := index + 1
		end

end

note
	description: "Summary description for {SORTED_BST_MAP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SORTED_BST_MAP [K -> COMPARABLE, V -> ANY]

inherit
	SORTED_MAP_DESIGN [K, V]

create
	make_empty, make_from_array, make_from_sorted_map


feature{NONE} -- attributes
	implementation: SORTED_BST [K,V]
			-- inefficient but abstract implementation of sorted map
		attribute
			create Result.make_empty
		end


	instance: like Current
		attribute
			create Result.make_empty
		end

end


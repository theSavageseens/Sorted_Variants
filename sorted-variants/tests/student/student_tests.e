note
	description: "Summary description for {STUDENT_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TESTS
inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
		end

	bst_map: SORTED_BST_MAP [INTEGER, PERSON]
		attribute
			create Result.make_empty
		end

	rbt_map: SORTED_RBT_MAP[INTEGER, PERSON]
		attribute
			create Result.make_empty
		end

	linear_map: SORTED_LINEAR_MAP[INTEGER, PERSON]
		attribute
			create Result.make_empty
		end

	map: SORTED_BST_MAP [INTEGER, PERSON]
		attribute
			create Result.make_empty
		end

feature
	t1: BOOLEAN
		do
			comment("t1: testing extend and remove in BST")
			bst_map.extend (3, "a")
			bst_map.extend (4, "b")
			bst_map.extend (5, "c")
			bst_map.extend (9, "d")
			bst_map.extend (8, "e")
			bst_map.extend (7, "f")
			Result := bst_map.out ~ "(3,a)(4,b)(5,c)(7,f)(8,e)(9,d)"
			check Result end
			bst_map.remove(4)
			bst_map.remove(9)
			Result := bst_map.out ~ "(3,a)(5,c)(7,f)(8,e)"
			check Result end

			bst_map.extend (2, "z")
			bst_map.extend (1, "x")
			Result := bst_map.out ~ "(1,x)(2,z)(3,a)(5,c)(7,f)(8,e)"
			check Result end
			bst_map.remove(1)
			bst_map.remove(2)
			bst_map.remove(3)
			bst_map.remove(5)
			Result := bst_map.out ~ "(7,f)(8,e)"
			check Result end
		end

	t2: BOOLEAN
		do
			comment("t2: find min/max based on extend and remove")
			linear_map.extend (11, "a")
			linear_map.extend (12, "b")
			linear_map.extend (13, "c")
			linear_map.extend (14, "d")
			linear_map.extend (15, "e")
			linear_map.extend (16, "f")
			Result := linear_map.min.key ~ 11
			check Result end
			Result := linear_map.min.val ~ "a"
			check Result end
			linear_map.remove(11)
			Result := linear_map.min.key ~ 12
			check Result end
			Result := linear_map.min.val ~ "b"
			check Result end

			Result := linear_map.max.key ~ 16
			check Result end
			Result := linear_map.max.val ~ "f"
			check Result end
			linear_map.remove(16)
			Result := linear_map.max.key ~ 15
			check Result end
			Result := linear_map.max.val ~ "e"
			check Result end
		end

	t3: BOOLEAN
		do
			comment("t3: testing prune and prune_all")
			rbt_map.extend (1, "a")
			rbt_map.extend (2, "a")
			rbt_map.extend (3, "a")
			rbt_map.extend (4, "b")
			rbt_map.extend (5, "b")
			rbt_map.extend (6, "b")
			rbt_map.extend (7, "b")
			rbt_map.extend (8, "a")
			Result := rbt_map.out ~ "(1,a)(2,a)(3,a)(4,b)(5,b)(6,b)(7,b)(8,a)"
			check Result end
			rbt_map.prune_tolerant ("a", 2)
			Result := rbt_map.out ~ "(1,a)(3,a)(4,b)(5,b)(6,b)(7,b)(8,a)"
			check Result end
			rbt_map.prune_tolerant ("a", 2)
			Result := rbt_map.out ~ "(1,a)(4,b)(5,b)(6,b)(7,b)(8,a)"
			check Result end
			rbt_map.prune_tolerant ("a", 2)
			Result := rbt_map.out ~ "(1,a)(4,b)(5,b)(6,b)(7,b)"
			check Result end

			rbt_map.prune_all ("b")
			Result := rbt_map.out ~ "(1,a)"
			check Result end
			rbt_map.prune_all ("a")
			Result := rbt_map.out ~ ""
			check Result end
		end

	t4: BOOLEAN
		do
			comment("t4: testing replace_key and replace")
			rbt_map.extend (1, "a")
			rbt_map.extend (2, "b")
			rbt_map.extend (3, "c")
			rbt_map.extend (4, "d")
			rbt_map.extend (5, "e")
			rbt_map.extend (6, "f")
			Result := rbt_map[4] ~ "d"
			check Result end
			rbt_map.replace_key (4, 7)
			Result := rbt_map[7] ~ "d"
			check Result end
			Result := rbt_map.out ~ "(1,a)(2,b)(3,c)(5,e)(6,f)(7,d)"
			check Result end

			rbt_map.remove (1)
			rbt_map.remove (2)
			rbt_map.replace_key (3, 1)
			rbt_map.replace_key (5, 2)
			Result := rbt_map[1] ~ "c"
			check Result end
			Result := rbt_map[2] ~ "e"
			check Result end
			Result := rbt_map.out ~ "(1,c)(2,e)(6,f)(7,d)"
			check Result end

			rbt_map.replace (1, "a")
			Result := rbt_map[1] ~ "a"
			check Result end
			rbt_map.replace (2, "b")
			Result := rbt_map[2] ~ "b"
			check Result end
			Result := rbt_map.out ~ "(1,a)(2,b)(6,f)(7,d)"
			check Result end
		end

	t5: BOOLEAN
		local
			other: like map
		do
			comment("t5: testing merge")
			other := map.deep_twin
			other.extend(1, "1")
			other.extend(2, "2")
			other.extend(3, "3")
			other.extend(4, "4")
			other.extend(5, "5")
			other.extend(6, "6")
			map.extend (7, "7")
			map.extend (8, "8")
			map.extend (9, "9")
			map.extend (10, "10")
			map.extend (11, "11")
			map.extend (12, "12")
			map.merge(other)

			Result := map.out ~ "(1,1)(2,2)(3,3)(4,4)(5,5)(6,6)(7,7)(8,8)(9,9)(10,10)(11,11)(12,12)"
			check Result end
		end
end

/* 
%  Project: FLP, 2. project - Spanning tree
%  author: Filip Brna, xbrnaf00
%  date: 19.4.2023
*/

start :-
		prompt(_, ''), 
		read_lines(LL),
		split_lines(LL,EdgesInListNoFilter),
		filter_uppercase(EdgesInListNoFilter, EdgesInListNoSort),
		sort(EdgesInListNoSort, EdgesInList),
		simplify(EdgesInList, Edges),
		sort(Edges, EdgesSorted),
		remove_self_loops(EdgesSorted,EdgesNoSelfLoops),
		unique_Nodes(EdgesSorted, Nodes),

		/**
		% sometimes all_visited is not that effective when many edges are given and it can run out of global or local stack
		% version without all_visited is more effective but it does not check if graph is connected
		*/

		[First|_] = Nodes,
		(all_visited(First, Nodes, EdgesSorted) -> 
			length(Nodes, NumOfNodes),
			ExpectedLen is NumOfNodes - 1,
			generate_combinations(EdgesNoSelfLoops, ExpectedLen, Combinations),
			filter_trees_without_all_nodes(Combinations, Nodes, NumOfNodes, FilteredTrash),
			filter_equivalent_trees(FilteredTrash, _), halt
			; halt).

		/** 
		% if you want to use part below, uncomment it and comment part above (all_visited(First, Nodes, EdgesSorted) -> ... ; halt.)  
		length(Nodes, NumOfNodes),
		ExpectedLen is NumOfNodes - 1,
		generate_combinations(EdgesNoSelfLoops, ExpectedLen, Combinations),
		filter_trees_without_all_nodes(Combinations, Nodes, NumOfNodes, FilteredTrash),
		filter_equivalent_trees(FilteredTrash, _),
		halt. */	

/**
% functions to test graph connectivity
% from starting one it tries to visit every graph node if its succesfull then return true else false 
*/

all_visited(_, [], _).
all_visited(StartNode, [Node|Rest], Edges) :-
    StartNode \= Node,
    reachable(StartNode, Node, Edges),
    all_visited(StartNode, Rest, Edges).
all_visited(StartNode, [Node|Rest], Edges) :-
    StartNode == Node,
    all_visited(StartNode, Rest, Edges).

reachable(StartNode, Node, Edges) :-
    member([StartNode, Node], Edges).
reachable(StartNode, Node, Edges) :-
    member([StartNode, Middle], Edges),
    reachable(Middle, Node, Edges).

/** provides print of spanning tree on output */
print_output([]) :- nl.
print_output([Combination]) :-
	print_combination(Combination).
print_output([Combination|Rest]) :-
	print_combination(Combination),
	print_output(Rest).

/** print given combinations of edges on output according to the project specification */
print_combination([]) :- nl.
print_combination([[From,To]]) :-
	write(From), write('-'), write(To), write(' '), nl.
print_combination([[From,To]|Rest]) :-
	write(From), write('-'), write(To), write(' '),
	print_combination(Rest).

/** 
% removes all combinations of spanning trees which are permutations of spanning trees in result list
% after removing all permutations, the result list is sorted and called print_output function
*/
filter_equivalent_trees([], Result) :-
	sort(Result, SortedResult),
	print_output(SortedResult).
filter_equivalent_trees([Combination|Rest], []) :-
    filter_equivalent_trees(Rest, [Combination]).
filter_equivalent_trees([Combination|Rest], Result) :-
	(is_permutation(Combination, Result) -> filter_equivalent_trees(Rest, Result); filter_equivalent_trees(Rest, [Combination|Result])).

/** returns true if given combination is permutation of any combination in given list */
is_permutation(_, []) :- false.
is_permutation(Combination1, [Combination2|Rest]) :-
    permutation(Combination1, Combination2) -> true; is_permutation(Combination1, Rest). 

/** filters combinations that do not contain all nodes */
filter_trees_without_all_nodes([], _, _, []).
filter_trees_without_all_nodes([Combination|Rest], Nodes, NumOfNodes, Result) :-
        unique_Nodes(Combination, UniqueNodes),
        length(UniqueNodes, UniqueNodesLen),
        (UniqueNodesLen == NumOfNodes ->
            Result = [Combination|RestResult],
            filter_trees_without_all_nodes(Rest, Nodes, NumOfNodes, RestResult)
        ; filter_trees_without_all_nodes(Rest, Nodes, NumOfNodes, Result)).

/** generate all combinations of given length from edges */
generate_combinations(Edges, N, Combinations) :-
    N > 0,
    findall(Combination,
            (combinations(Edges, N, Combination)),
            Combinations).

combinations(_, 0, []).
combinations(Edges, N, [Edge|Combination]) :-
    N > 0,
    member(Edge, Edges),
	/** delete Edge from Edges and returns list of remaining edges in RemainingEdges */
    select(Edge, Edges, RemainingEdges), 
    N1 is N - 1,
    combinations(RemainingEdges, N1, Combination).

/** returns sorted list of unique Nodes from given edges, example: [[A,B],[A,C]] -> [A,B,C] */
unique_Nodes(List, UniqueListSorted) :-
    flatten(List, FlatList),
    list_to_set(FlatList, UniqueList),
	sort(UniqueList, UniqueListSorted).

/** removes self loops from given edges, example: [[A,A],[B,C]] -> [[B,C]] */
remove_self_loops([], []).
remove_self_loops([[From,To]|Tail],Removed) :-
				(From \= To -> Removed = [[From,To]|Result]; Removed = Result),
				remove_self_loops(Tail, Result).

/** simplify given edges to more practical and readable form, example: [[[A],[B]],[[A],[C]]] -> [[A,B],[A,C]] */
simplify([], []).
simplify([[[A],[B]]|T], [[A,B]|Result]) :-
    simplify(T, Result).


/** from given list remove invalid edges, example: [[[C],[D]],[[a],[b]],[[D],[E]],[[1],[2]]] ->  [[[C],[D]],[[D],[E]]]*/
filter_uppercase([], []).
filter_uppercase([H|T], [H|Filtered]) :-
    H = [[V1],[V2]],
    char_type(V1, upper),
    char_type(V2, upper),
    filter_uppercase(T, Filtered).
filter_uppercase([_|T], Filtered) :-
    filter_uppercase(T, Filtered).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/** the following code was taken from input2.pl, which was provided as sample code in the FLP subject */

/** reads lines from standard input, ends in LF or EOF */
read_line(L,C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
		read_line(LL,_),
		[C|LL] = L).

/** test char on EOF or LF */
isEOFEOL(C) :-
	C == end_of_file;
	(char_code(C,Code), Code==10).

read_lines(Ls) :-
	read_line(L,C),
	( C == end_of_file, Ls = [] ;
        read_lines(LLs), Ls = [L|LLs]
	).

/** divides line into sub-lists */
split_line([],[[]]) :- !.
split_line([' '|T], [[]|S1]) :- !, split_line(T,S1).
split_line([32|T], [[]|S1]) :- !, split_line(T,S1).    % aby to fungovalo i s retezcem na miste seznamu
split_line([H|T], [[H|G]|S1]) :- split_line(T,[G|S1]). % G je prvni seznam ze seznamu seznamu G|S1

/** the input is a list of lines (each line is a list of characters) */
split_lines([],[]).
split_lines([L|Ls],[H|T]) :- split_lines(Ls,T), split_line(L,H).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
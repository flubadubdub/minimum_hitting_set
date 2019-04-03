% select the shortest (minimum) hitting set from a generated list of them.

% subsequence(X, Y) succeeeds when list X is more the same as list Y, but with zero or more elements omitted.
% This can be used with any pattern of instantiations.
subsequence([], []).
subsequence([Head | TailX], [Head | TailY]) :- subsequence(TailX, TailY).
subsequence(X, [_ | TailY]) :- subsequence(X, TailY).

% shorestList(L1, L2) will take a list of lists and return the list with the least elements as L2
shortestList([L], L).
shortestList([Head | Tail], L2) :-
    length(Head, List),
    shortestList(Tail, L2),
    length(L2, L3),
    List > L3.
shortestList([Head | Tail], Head) :-
    length(Head, List),
    shortestList(Tail, List),
    length(List, L3),
    List >= L3.

/* built-in prolog predicates placed here for reference, taken from eclipseclp.org */

% built-in prolog predicate memberchk(X, L) succeeds if X is a member of the list L
memberchk(X, [X | _]) :- !.
memberchk(X, [_ | Tail]) :- memberchk(X, Tail).

% built-in prolog predicate union(L1, L2, L3) succeeds if L3 is the list which contains the union of elements
% in L1 and those in L2
union([], L, L).
union([Head | L1tail], L2, L3) :-
        memberchk(Head, L2),
        !,
        union(L1tail, L2, L3).
union([Head | L1tail], L2, [Head | L3tail]) :- union(L1tail, L2, L3tail).

% built-in prolog predicate intersection(L1, L2, Common) succeeds if common unifies with the list containing
% elements in both L1 and L2
intersection([], _, []).
intersection([Head | L1tail], L2, L3) :-
        memberchk(Head, L2),
        !,
        L3 = [Head | L3tail],
        intersection(L1tail, L2, L3tail).
intersection([_ | L1tail], L2, L3) :- intersection(L1tail, L2, L3).

% findall(Term, Goal, List) unifies List with the list of all instances of the Term such that Goal is satisfied
% *no provided implementation*

% wrapper predicate unionize(L1, L2) creates a union between two sets using the union predicate
unionize([], []).
unionize([Head | Tail], L2) :-
    unionize(Tail, L3),
    union(Head, L3, L2).

% wrapper predicate intersect(L1, L2) creates an intersection between two sets using the intersection predicate
% and continues until all lists in the given list of lists are intersected
intersect([], _).
intersect([Head | Tail], L2) :-
    intersection(Head, L2, L3),
    L3 \== [],
    intersect(Tail, L2).

% predicate hittingSet(L1, L2) succeeds if L2 is a subsequence of L1, then if L1 intersects with L2
hittingSet(L1, L2) :-
    unionize(L1, X),
    subsequence(L2, X),
    intersect(L1, L2).

% predicate minHittingSet(Sets, Solution) finds the smallest set which acts as a minimum hitting set for the given
% set of sets. L1 represents the subsets of the given Sets, and L2 represents a list of hitting sets.
minHittingSet([], []).
minHittingSet(Sets, Solution) :-
    findall(L1, hittingSet(Sets, L1), L2),
    shortestList(L2, Solution).
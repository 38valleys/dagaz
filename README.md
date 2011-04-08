This is a style file for bibtex based on alpha.bst.
The main difference from alpha.bst is the labelling rule.

Labelling Rules
==================================

The label of each reference is determined only by its author(s).

(labelling rules are to be explained here)

Example of Output
----------------------

For example, the output will be as follows
(guess how the labels are determied by the name of authors!)

 [B]  S. H. Brook, "How to survive --- although I am already dead", ...

 [Cho] T. T. Chopper, "On a problem about medical treatment on the sea", .,.

 [Cr1] S. Crocodile, "An efficient way of managing a large community", ...

 [Ch2] S. Crocodile, "A new method of analysing sands", ...

 [V-Chr]  M. Valentine and M. M. Christmas, "Women in a company", ...


Fixing Orders
----------------------

(How to indicate a bibliography that must be
 put at the top/bottom of your references)


Note
==================================

So far, this bst file can treat only entries of type
    article, book or phdthesis.
Even if your bib file includes other types of entries,
you can compile it via bibtex command, but
the output may be so strange.


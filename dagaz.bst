% This is a BibTeX style file dagaz.bst, based on alpha.bst.
	% version 0.99a for BibTeX versions 0.99a or later, LaTeX version 2.09.
	% Copyright (C) 1985, all rights reserved.
	% Copying of this file is authorized only if either
	% (1) you make absolutely no changes to your copy, including name, or
	% (2) if you do make changes, you name it something other than
	% btxbst.doc, plain.bst, unsrt.bst, alpha.bst, dagaz.bst, and abbrv.bst.
	% This restriction helps ensure that all standard styles are identical.

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
    position
  }
  {}
  { authors raw.label label extra.label sort.label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }
INTEGERS { num.author.list }
STRINGS { author.list abbr.author.list }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

INTEGERS { n m }
STRINGS { s t l }

FUNCTION {output.nonnull}
{
  's :=
  output.state mid.sentence =
    'write$
    { output.state after.block =
        { write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.bibitem}
% Writes \bibitem commands to the bbl file.
{ newline$
  "\bibitem[" write$
  label write$
  "]{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
% Puts \em command
{
  duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

FUNCTION {bold}
% Puts \bf command
{
  duplicate$ empty$
    { pop$ "" }
    { "{\bf " swap$ * "}" * }
  if$
}

INTEGERS { n1 n2 }

FUNCTION {max}
{
   'n2 := 'n1 :=
   n1 n2 >
   { n1 }
   { n2 }
   if$
}

FUNCTION {position.space}
% Returns the position of the first space (0 if no spaces).
{
  's :=                 % argument
  #1 'n :=              % position 
  
  { s n #1 substring$ " " = not         % while the 1-st char of s is not " "
    n s text.length$ > not and}         % and n <= (length of s)
  { n #1 + 'n := }      % add 1 to n 
  while$

  n s text.length$ >    % if n > (length of s)
    { #0 }              % return 0
    { n }               % if not, return n
  if$
}

FUNCTION {cut.by.space}
% Cuts the string before the first space.
% Returns two strings ( before-the-space & after-the-space )
% If there are no spaces, before=full and after=" ".
{
  's :=                  % argument
  s position.space 'n :=        % position of the 1-st space
  
  n #0 =                 % if there are no spaces
  {
   s ""                  % return s as "before" and " " as "after"
  }
  {                      % if there is a space
    s #1 n #1 - substring$              % return the string before the space
    s n #1 + s text.length$ substring$  % return the string after the space
  } 
  if$
  "" 's :=
}

INTEGERS { ap }
STRINGS  { match try }

FUNCTION {position.in.author.list}
% Returns position of the given string in author.list
% Returns 0 if it does not appear.
{
  'match :=                  % argument
  author.list 'l :=
  #0 'ap :=              % Author's Position
  "" 'try :=

  { try match = not l "" = not and }  % while try is not match and l is not run out of
  {
    ap #1 + 'ap :=         % add 1 to ap 
    l cut.by.space 'l := 'try :=  % divide l to try & l 
  }
  while$

  try match =                  % if s has occured in the list
  { ap }                  % return n
  { #0 }                 % otherwise, return 0
  if$
}

STRINGS  { s1 s2 }
INTEGERS { len1 len2 stop }

FUNCTION {fetch.from.list}
% Return m-th member of abbr.author.list
{
  'm :=
  #1 'len1 :=
  abbr.author.list 's1 :=
  
  { len1 m < }
  {
    s1 cut.by.space 's1 := pop$
    len1 #1 + 'len1 :=
  }
  while$
  s1 cut.by.space pop$
}

FUNCTION {greater.str}
% Compares two strings with respect to the alphabetical order
{
  's2 := s2 text.length$ 'len2 :=
  's1 := s1 text.length$ 'len1 :=
  #0 'n := #0 'stop :=

  { n len1 > n len2 > stop or or not }
  {
    n #1 + 'n :=
    n len1 > n len2 > or
      { #1 'stop := }
      { s1 n #1 substring$ chr.to.int$ s2 n #1 substring$ chr.to.int$ = not 'stop := }
    if$
  }
  while$

  n len1 >
    { #0 }
    {
      n len2 >
        { #1 }
        {
          s1 n #1 substring$ chr.to.int$ s2 n #1 substring$ chr.to.int$ >
            { #1 }
            { #0 }
          if$
        }
      if$
    }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
% Formats names of authors for the entry of \bibitem.
{
  's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{f.~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    {
	      t "others" =
		{ " et~al." * }
		{ " and " * t * }
	      if$
	    }
	  if$
	}
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
  "," *
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names duplicate$ text.length$ #1 - #1 swap$ substring$
      editor num.names$ #1 >
	{ " eds." * }
	{ " ed." * }
      if$
    }
  if$
}

FUNCTION {format.title}
{
   title empty$
    { "" }
    { "``" title "t" change.case$ emphasize ",''" * * }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
	{ "" }
	{ "there's a month but no year in " cite$ * warning$
	  month
	}
      if$
    }
    { month empty$
        'year
	{ month " " * year * }
      if$
    }
  if$
}

FUNCTION {format.btitle}
% Formats the title of books
{
  "``" title emphasize ",''" * * 
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{
  volume empty$
    { "" }
    {
      series empty$
	{ "" }
        { series " " * }
      if$
      volume bold * "," *
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	{ series field.or.null }
	{ output.state mid.sentence =
	    { "number" }
	    { "Number" }
	  if$
	  number tie.or.space.connect
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { " in " * series * }
	  if$
	}
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
	{ edition "l" change.case$ " edition" * }
	{ edition "t" change.case$ " edition" * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
	{ pages n.dashify }
	{ pages }
      if$
    }
  if$
}

FUNCTION {format.vol.year.num.pages}
% Formats as "vol (year) pages"
{ 
  " " volume field.or.null bold *
  number empty$
    'skip$
    { "(" number * ")" * *
      volume empty$
	{ "there's a number but no volume in " cite$ * warning$ }
	'skip$
      if$
    }
  if$
  " (" format.date ")" * * *
  pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ format.pages }
	{ ", " * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ "chapter" }
	{ type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
	'skip$
	{ ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
	{ "in " booktitle * }
	{ "in " booktitle * ", " * format.editors * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
	{ "In {\em " journal * "\/}" * }
      if$
    }
    { "In " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
	'skip$
	{ editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
	    { " et~al." * }
	    { " and " * editor #2 "{vv~}{ll}" format.name$ * }
	  if$
	}
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "in "
    }
    { "Volume" volume tie.or.space.connect
      " of " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ series empty$
	    { "need editor, key, or series for " cite$ * " to crossref " *
	      crossref * warning$
	      "" *
	    }
	    { "{\em " * series * "\/}" * }
	  if$
	}
	{ key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ booktitle empty$
	    { "need editor, key, or booktitle for " cite$ * " to crossref " *
	      crossref * warning$
	      ""
	    }
	    { "in " booktitle * }
	  if$
	}
	{ "in " key * }
      if$
    }
    { "In " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { journal "journal" output.check
      format.vol.year.num.pages output
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors ", " * write$ } %"author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
  new.block
  crossref missing$
    { format.bvolume output
      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date empty$
    'skip$
    { ", " format.date * "year" output.check }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      format.chapter.pages "chapter and pages" output.check
      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.chapter.pages output
      new.sentence
      publisher "publisher" output.check
      address output
      format.edition output
      format.date "year" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors write$
  new.block
  " " format.title * write$
  new.block
  crossref missing$
    { " " format.in.ed.booktitle * write$
      format.bvolume output
      format.number.series output
      address empty$
	{ organization publisher new.sentence.checkb
	  organization output
	  ", " publisher * output
	  ", " format.date * "year" output.check
	}
	{ address output.nonnull
	  ", " format.date * "year" output.check
	  new.sentence
	  organization output
	  publisher output
	}
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
    }
  if$
  ", pp." format.pages * output
  new.block
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
	'skip$
	{ organization output.nonnull
	  address output
	}
      if$
    }
    { format.authors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  author empty$
    { organization empty$
	{ address new.block.checka
	  address output
	}
	'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.date output
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check
  new.block
  "PhD thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
	{ publisher new.sentence.checka }
	{ organization publisher new.sentence.checkb
	  organization output
	}
      if$
      publisher output
      format.date "year" output.check
    }
    { address output.nonnull
      format.date "year" output.check
      new.sentence
      editor empty$
	'skip$
	{ organization output }
      if$
      publisher output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  note "note" output.check
  format.date output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

INTEGERS { et.al.char.used }

FUNCTION {initialize.et.al.char.used}
{ #0 'et.al.char.used :=
}

EXECUTE {initialize.et.al.char.used}

INTEGERS { noloop }
STRINGS { arg list result }

FUNCTION {conj.with.author.list}
% Adds string to the author.list in the alphabetical order
{
  'arg :=                       % argument
  "" 'result :=

  author.list "" =
    { arg 'result := }          % if author.list is empty, s is author.list
    {
      author.list 'list :=
      " " 't :=
      #1 'noloop :=
      
      { noloop list empty$ not and }
      {
        t " " =
          'skip$
          {
            result empty$
              { t }
              { result " " t * * }
            if$
            'result :=
          }
        if$
        list cut.by.space pop$ 't :=
        arg t greater.str
          { list cut.by.space 'list := pop$ }
          { #0 'noloop := }
        if$
      }
      while$  

      result empty$
        { arg }
        { result " " arg * * }
      if$
      list empty$
        { pop$ author.list " " arg * * }
        { " " list * * }
      if$
      'result := 
    }
  if$

  result 'author.list :=
}

FUNCTION {change.name}
% Changes specific names
{
  duplicate$
  "LeStum" =
    { pop$ "LS'" }
    'skip$
  if$
} 

STRINGS { added }

FUNCTION {add.to.author.list}
% Adds to author.list in a certain format if necessary
{
  'added :=
  added num.names$ 'numnames :=

  #1 'nameptr :=
  { nameptr numnames > not }
  {
    added nameptr "{v{}}{ll{}}" format.name$
    duplicate$
    position.in.author.list #0 = author.list "" = or
      'conj.with.author.list
      'pop$
    if$
    nameptr #1 + 'nameptr :=
  }
  while$
  
  ""
}

FUNCTION {calc.authors}
% Calculate list of authors for each entry
{
  author 's :=
  s num.names$ 'numnames :=
  "" 'authors :=

  #1 'nameptr :=
  { nameptr numnames > not }
  {
    nameptr #1 =
      'skip$
      { authors " " * 'authors := }
    if$
    authors
    s nameptr "{v{}}{ll{}}" format.name$ 
    * 'authors :=
    nameptr #1 + 'nameptr :=
  }
  while$
}  

FUNCTION {author.key.label}
{ author empty$
    { key empty$
        { cite$ #1 #3 substring$ }
	{ key #3 text.prefix$ }
      if$
    }
    { author add.to.author.list }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
	{ key empty$
            { cite$ #1 #3 substring$ }
	    { key #3 text.prefix$ }
	  if$
	}
	{ editor add.to.author.list }
      if$
    }
    { author add.to.author.list }
  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
	{ organization empty$
	    { cite$ #1 #3 substring$ }
	    { "The " #4 organization chop.word #3 text.prefix$ }
	  if$
	}
	{ key #3 text.prefix$ }
      if$
    }
    { author add.to.author.list }
  if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
	{ organization empty$
	    { cite$ #1 #3 substring$ }
	    { "The " #4 organization chop.word #3 text.prefix$ }
	  if$
	}
	{ key #3 text.prefix$ }
      if$
    }
    { editor add.to.author.list }
  if$
}

FUNCTION {make.author.list}
% Finally decides author.list
{
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
	'editor.key.organization.label
	{ type$ "manual" =
	    'author.key.organization.label
	    'author.key.label
	  if$
	}
      if$
    }
  if$
  duplicate$
  'label :=
  sortify 'sort.label :=
}

INTEGERS { mpre }
STRINGS { al aal }

FUNCTION {make.abbr.author.list}
% Finally decides abbr.author.list
{
   author.list 'al :=
   "" 'aal := 
   #1 'mpre :=

   { al empty$ not }
   {
     al cut.by.space 'al := 't :=
     #1 'm :=
     #1 'noloop :=
     { noloop }
     {
       t #1 m substring$
       al cut.by.space pop$ #1 m substring$ =
         { m #1 + 'm := }
         { #0 'noloop := }
       if$ 
     }
     while$
     abbr.author.list t #1 m mpre max substring$ " " * * 'abbr.author.list :=
     m 'mpre :=
   }
   while$
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
	{ "   " * }
	'skip$
      if$
      s nameptr "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
	{ "et al" * }
	{ t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
	{ "to sort, need author or key in " cite$ * warning$
	  ""
	}
	{ key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
	{ key empty$
	    { "to sort, need author, editor, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
	{ key empty$
	    { "to sort, need author, organization, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
	{ key empty$
	    { "to sort, need editor, organization, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {calc.label}
{
  calc.authors

  key empty$
    {
      authors 's2 :=
      #1 'len2 :=
      { s2 empty$ not }
      {
        s2 cut.by.space 's2 := 'al :=
        al change.name 'al :=
        al #-1 #1 substring$ "'" =
        { al #1 al text.length$ #1 - substring$ 'al := }
        { al position.in.author.list fetch.from.list 'al := }
        if$
        len2 #1 =
        { al #0 'len2 := }
        { "-" al * * }
        if$
      }
      while$
      duplicate$ 'label := 'sort.label :=
    }
    { 
      key duplicate$ 'label :=
      position "head" =
        { "     " swap$ * }
        'skip$
      if$
      'sort.label :=
    }
   if$ 
}


FUNCTION {presort}
{
  calc.label
  sort.label
  "    "
  *
  type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
	'editor.organization.sort
	{ type$ "manual" =
	    'author.organization.sort
	    'author.sort
	  if$
	}
      if$
    }
  if$
  *
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {make.author.list}
EXECUTE {make.abbr.author.list}
ITERATE {presort}

SORT

STRINGS { longest.label last.sort.label next.extra }

INTEGERS { longest.label.width last.extra.num }

%FUNCTION {initialize.longest.label}
%{ "" 'longest.label :=
%  #0 int.to.chr$ 'last.sort.label :=
%  "" 'next.extra :=
%  #0 'longest.label.width :=
%  #0 'last.extra.num :=
%}

FUNCTION {forward.pass}
{ last.sort.label sort.label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.str$ 'extra.label :=
    }
    { #1 'last.extra.num :=
      "" 'extra.label :=
      sort.label 'last.sort.label :=
    }
  if$
}

FUNCTION {reverse.pass}
{ next.extra "2" =
    { "1" 'extra.label := }
    'skip$
  if$
  label extra.label * 'label :=
  %label width$ longest.label.width >
  %  { label 'longest.label :=
  %    label width$ 'longest.label.width :=
  %  }
  %  'skip$
  %if$
  extra.label 'next.extra :=
}

%EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {begin.bib}
{ et.al.char.used
    { "\newcommand{\etalchar}[1]{$^{#1}$}" write$ newline$ }
    'skip$
  if$
  preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{99}" write$ newline$
  "\itemsep=0pt" write$ newline$
  "\parskip=0pt" write$ newline$
  "\small" write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}

%FUNCTION {debug}
%{
%  "author.list = " author.list * top$
%  author.list text.length$ int.to.str$ " letters." * top$
%  "abbr.author.list = " abbr.author.list * top$
%}
%
%EXECUTE {debug}

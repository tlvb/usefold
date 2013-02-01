function! Usefold_Folder(fblno) "{{{
	let fmarks = split(&foldmarker, ',')
	let fbeg = printf(&commentstring, fmarks[0])
	let fend = printf(&commentstring, fmarks[1])
	let il = indent(a:fblno)
	let felno = a:fblno + 1
	let lnosav = felno
	while (indent(felno) > il || match(getline(felno), '\S') == -1) && indent(felno) != -1
		if match(getline(felno), '\S') != -1
			let lnosav = felno
		endif
		let felno = felno + 1
	endwhile

	echo lnosav
	if &filetype == "python"
		let felno = lnosav
		call setline(a:fblno, substitute(getline(a:fblno), '$', ' '.fbeg, ''))
		call append(felno, repeat(' ', il) . fend)
	else
		if match(getline(felno), '\S') == -1
			let felno = lnosav
		end
		call setline(a:fblno, substitute(getline(a:fblno), '$', ' '.fbeg, ''))
		call setline(felno, substitute(getline(felno), '$', ' '.fend, ''))
	endif
endfunction "}}}

function! Usefold_FromHere() "{{{
	call Usefold_Folder(line('.'))
endfunction "}}}

function! Usefold_FromInside() "{{{
	let l = line('.')
	while match(getline(l), '\S') == -1 && l > 0
		let l = l - 1
	endwhile
	let il = indent(l)
	if il == 0
		return
	endif
	while l > 0 && (indent(l) >= il || match(getline(l), '\S') == -1)
		let l = l - 1
	endwhile
	if indent(l) > -1
		call Usefold_Folder(l)
	endif
endfunction "}}}

function! Usefold_foldtext() "{{{
	let fmarks = split(&foldmarker, ',')
	let fbeg = printf(&commentstring, fmarks[0])
	let fend = printf(&commentstring, fmarks[1])
	let fbline = substitute(getline(v:foldstart), '^\s*\(.\{-}\)\s*'.fbeg.'$' , '\1', '')
	let feline = substitute(getline(v:foldend), '\s*\(\S*\)\s*'.fend.'$' , '\1', '')
	let linec = v:foldend - v:foldstart - 1
	let linecs = 'lines'
	if linec == 1
		let linecs = 'line'
	endif
	return repeat(" ", indent(v:foldstart)) . fbline . ' ... (' . linec . ' ' . linecs . ') ... ' . feline
endfunction "}}}

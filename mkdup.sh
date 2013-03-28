#!/bin/sh
#please add code in ~/.vimrc
#nmap <F3> :call Wd()<CR>
#function! Wd()
#	echo "mkdup".bufname("%")
#	!~/bin/mkdup.sh % diffpre
#	w
#	echo "diffdup".bufname("%")
#	!~/bin/mkdup.sh % diff
#endfunction

path_dir_diff="${HOME}/.root"
init(){
  if [ ! -e ${file} ] ;then
     echo "${file} is not exists."
     exit 2
  fi
  dir=`dirname ${file}`
  diff_file="${path_dir_diff}${file}"
  test -d "${path_dir_diff}${dir}" || mkdir -p "${path_dir_diff}${dir}"
  if [ ! -d ${path_dir_diff}${dir} ] ; then
   echo "${path_dir_diff}${dir} don't create dir."
   exit 2
  fi
}
mkdup(){
 if [ -f ${file} ] ; then
  cp ${file} ${diff_file} && echo "cp ${file} ${diff_file}"
  exit 0
 fi
 if [ -d ${file} ] ; then
  cp -r ${file} ${path_dir_diff}${dir} && echo "cp ${file}/* ${path_dir_diff}${dir}"
  exit 0
 fi
 echo "${file} don't access."
}
chkfile(){
 if [ ! -w ${file} ]  || [ ! -f ${file} ] ; then
  echo "${file} don't access or not is file ."
  exit 2
 fi
}
diffpre(){
 chkfile
 if [ ! -f ${diff_file} ] ; then
  cp ${file} ${diff_file} && echo "cp ${file} ${diff_file}"
 fi
}
diffdup(){
 chkfile
 touch ${diff_file}.diff
 if [ -w "${diff_file}.diff" ] &&  [ -f ${diff_file} ]  ; then
  diff -Nu ${diff_file} ${file} >> ${diff_file}.diff
  diff -Nu ${diff_file} ${file}
  cp ${file} ${diff_file}
 else
  echo "${diff_file}.diff don't access."
 fi
}

file=`readlink -f $1`
case "$2" in
 "diffpre")
  init
  diffpre
 ;;
 "diff")
  init
  diffdup
 ;;
 *)
  init
  mkdup
 ;;
esac

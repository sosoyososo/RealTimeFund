main=document.getElementsByClassName("file_t_left lt")[0]
for (i=0;i<document.body.childNodes.length;i++){
	node=document.body.childNodes[i]
	document.body.removeChild(node)
}
document.body.appendChild(main)
BEGIN {
    split(cols,out,",");OFS="\t";
}
NR==1 {
    for (i=1; i<=NF; i++)
        ix[$i] = i
    for (i in out)
        printf "%s%s", $ix[out[i]], OFS
    printf "\n"
}
NR>1 {
    for (i in out)
        printf "%s%s", $ix[out[i]], OFS
    printf "\n"
}

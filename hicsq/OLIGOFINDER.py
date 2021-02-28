def get_pass_parameters (pass_number):
    """Returns search parameters depending on which pass is underway"""
    if pass_number == 1:
        range_length = 80
        max_reps = 10
        min_GC = 50
        max_GC = 60
    elif pass_number == 2:
        range_length = 80
        max_reps = 10
        min_GC = 40
        max_GC = 70
    elif pass_number == 3:
        range_length = 110
        max_reps = 20
        min_GC = 40
        max_GC = 70
    elif pass_number == 4:
        range_length = 110
        max_reps = 25
        min_GC = 25
        max_GC = 80
    return (range_length, max_reps, min_GC, max_GC)

def repeat_test (oligo, max_reps):
    """Checks oligo for repetitive sequence based on masked FASTA seq"""
    passed = False
    rep_count = 0
    for i in range(0, len(oligo)):
        if oligo[i].islower() == True:
            rep_count += 1
    if rep_count < max_reps:
        passed = True
    return passed

def GC_test(oligo, min_GC = 0, max_GC = 100):
    """Checks oligo for GC content within specified range"""
    passed = False
    GCcount = 0
    for i in range(0, len(oligo)):
        if oligo[i]== 'G' or oligo[i] == 'C':
            GCcount += 1
    percentGC = (float(GCcount) / float(len(oligo))) * 100
    if percentGC >= min_GC and percentGC <= max_GC:
        passed = True
    return passed


def check_oligo (oligo, max_reps, min_GC, max_GC):
    passed = False
    passed_repeats = repeat_test(oligo, max_reps)
    passed_GC = GC_test(oligo.upper(), min_GC, max_GC)
    if passed_repeats == True and passed_GC == True:
        passed = True
    return passed

def get_oligo_up (sequence, prev, ind, pass_number, oligo_length=120):
    good_oligo = ("NONE", -1,- 1)
    if ind == -1:
        return good_oligo
    search_parameters = get_pass_parameters(pass_number)
    range_start = ind - search_parameters[0]
    search_start = ind
    while search_start > range_start and search_start > 0:
        oligo_start = search_start - oligo_length
        if oligo_start >= prev:
            oligo = sequence[oligo_start:search_start]
            if check_oligo(oligo, search_parameters[1], search_parameters[2], search_parameters[3]) == True:
                good_oligo = (oligo, oligo_start, search_start-1)
                return good_oligo
        search_start -= 1
    return good_oligo

def get_oligo_down (sequence, ind, next, pass_number, oligo_length=120):
    good_oligo = ("NONE", -1, -1)
    if ind == -1:
        return good_oligo
    if next == -1:
        next = len(sequence)
    search_parameters = get_pass_parameters(pass_number)
    search_start = ind
    search_end = ind + search_parameters[0]
    while search_start < search_end:
        oligo_end = search_start + oligo_length
        if oligo_end <= next:
            oligo = sequence[search_start:oligo_end]
            if check_oligo(oligo, search_parameters[1], search_parameters[2], search_parameters[3]) == True:
                good_oligo = (oligo, search_start, oligo_end-1)
                return good_oligo
        search_start += 1
    return good_oligo

def get_oligo_info (REloc, oligo, passnum, UorD):
    """[0]oligo start index [1]oligo end index [2]pass [3]up or down [4]distance from RE site [5]oligo sequence"""
    oligo_start_index = oligo[1]
    oligo_end_index = oligo[2]
    if UorD == "U":
        dist_from_RE = REloc - oligo_end_index
    elif UorD == "D":
        dist_from_RE = oligo_start_index - REloc
    return (oligo_start_index, oligo_end_index, passnum, UorD, dist_from_RE, oligo[0])

def get_unique_oligos(oligo_list):
    """Sorts oligo list, removes any duplicates or overlaps."""
    oligo_list = sorted(oligo_list)
    unique = [oligo_list[0]]
    for x in range (1, len(oligo_list)):
        if oligo_list[x][0] != oligo_list[x-1][0]:
            unique.append(oligo_list[x])
    return unique

def remove_overlapping_oligos(unique):
    """If two oligos overlap, keep the one with lower pass number OR the one closer to its RE site if pass numbers are equivalent"""
    nonoverlapping = []
    for i in range(1, len(unique)):
        if unique[i][0] > unique[i-1][1]:
            nonoverlapping.append(unique[i])
            if i == 1:
                nonoverlapping.insert(0,unique[i-1])
        elif unique[i][0] <= unique[i-1][1]:
            if unique[i][2] < unique[i-1][2]:
                nonoverlapping.append(unique[i])
            elif unique[i][2] > unique[i-1][2]:
                nonoverlapping.append(unique[i-1])
            elif unique[i][4] < unique[i-1][4]:
                nonoverlapping.append(unique[i])
            elif unique[i][4] > unique[i-1][4]:
                nonoverlapping.append(unique[i-1])
            else:
                if unique[i-1] not in nonoverlapping and unique[i] not in nonoverlapping:
                    nonoverlapping.append(unique[i])
    return sorted(nonoverlapping)

def scan_for_gaps(i, y, search_seq, search_seq_unmasked, REcutseq, info):
    #print("Searching for gaps")
    scan_complete = False
    if y == -1:
        stop = i+5
    else:
        stop = i+y
    for j in range(i, stop):
        this_oligo_end = info[j][1]                
        if y == -1 and j == i+4:
            scan_complete = True
            #print("scan_complete2: ", scan_complete)
            next_oligo_start = len(search_seq) - 4
        else:
            next_oligo_start = info[j+1][0] 
        if next_oligo_start - this_oligo_end >  110:
            search_start = this_oligo_end + 1
            search_end = next_oligo_start + 4
            while search_seq_unmasked.find(REcutseq, search_start, search_end) != -1:
                RElocation = search_seq_unmasked.find(REcutseq, search_start, search_end)
                #print(RElocation, " ", search_start, " ", search_end)
                #------UPSTREAM OLIGOS------
                U_oligo = get_oligo_up(search_seq, search_start, RElocation, 4)
                if U_oligo[0] != "NONE":
                    oligo_info = get_oligo_info(RElocation, U_oligo, 4, "U")
                    print(oligo_info)
                    return (oligo_info, scan_complete)                       
                #------DOWNSTREAM OLIGOS------
                next_RElocation = search_seq_unmasked.find(REcutseq, RElocation+1, search_end)
                if next_RElocation == -1:
                    next_RElocation = search_end - 4
                D_oligo = get_oligo_down(search_seq, RElocation, next_RElocation, 4)
                if D_oligo[0] != "NONE":
                    oligo_info = get_oligo_info(RElocation, D_oligo, 4, "D")
                    print(oligo_info)
                    return(oligo_info, scan_complete)
                search_start = RElocation + 1
            if scan_complete == True:
                return ("NONE", scan_complete)
                
    return ("NONE", scan_complete)

def fourth_pass_scan(search_seq, search_seq_unmasked, REcutseq, info, placeholder):
    scan_complete = False
    i = placeholder
    while i < len(info)-4:
        if i == 0:
            window_start1 = 0
        else:
            window_start1 = info[i][0]
        window_end1 = info[i+4][1]
        if window_end1 - window_start1 > 5000:
                search_results = scan_for_gaps(i, 4, search_seq, search_seq_unmasked, REcutseq, info)
                if search_results[0] != "NONE":
                    placeholder = i
                    return (search_results[0], search_results[1], placeholder)
        window_start2 = info[i][1]
        if i < len(info)-5:
            window_end2 = info[i+5][0]
            if window_end2 - window_start2 > 5000:
                search_results = scan_for_gaps(i, 5, search_seq, search_seq_unmasked, REcutseq, info)
                if search_results[0] != "NONE":
                    placeholder = i
                    return (search_results[0], search_results[1], placeholder)
        elif i == len(info)-5:
            window_end2 = len(search_seq)-1
            if window_end2 - window_start2 > 5000:
                search_results = scan_for_gaps(i, -1, search_seq, search_seq_unmasked, REcutseq, info)
                if search_results[0] != "NONE":
                    placeholder = i
                    return (search_results[0], search_results[1], placeholder)
                elif search_results[0] == "NONE":
                    return (search_results[0], search_results[1], placeholder)
            else:
                scan_complete = True
                print("scan_complete1: ", scan_complete)
                break
        i += 1
    return ("NONE", scan_complete, placeholder)


#-----------------------------------------------------------------------------------------------------------------
# CREATE SEARCH WINDOW FROM USER INPUT OF CHROMOSOME COORDINATES
#-----------------------------------------------------------------------------------------------------------------

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("chromosome", type=str)
parser.add_argument("start", type=int)
parser.add_argument("end", type=int)
parser.add_argument("region", type=str)
args = parser.parse_args()
chromosome = args.chromosome
chr_start = str(args.start)
chr_end = str(args.end)
region_num = args.region

import pybedtools
from pybedtools import BedTool
hg19fa = '/bar/genomes/hg19/bwa/hg19.fa' #REFERENCE GENOME

"""print("\n\n--- Specify search window: ")
chromosome = input("Enter chromosome number, ex.'chr1': ").lower()
chr_start = input("Enter starting position, ex. '1': ")
chr_end = input("Enter ending position, ex. '2': ")"""

bedseq = chromosome + '\t' + chr_start + '\t' + chr_end
print("--- Searching for: " + bedseq)
bedfile = pybedtools.BedTool(bedseq, from_string=True)

fasta_order = bedfile.sequence(fi=hg19fa)

whole_sequence = ' '
lines = open(fasta_order.seqfn).readlines()
for line in lines:
	if line[0] != ">":
		 whole_sequence += line.strip()

#-----------------------------------------------------------------------------------------------------------------
# FIND CANDIDATE OLIGOS FROM SENSE STRAND
#-----------------------------------------------------------------------------------------------------------------

REcutseq = "GATC" #MboI RESTRICTION SITE
search_seq = whole_sequence
search_seq_unmasked = search_seq.upper() 

info = [] #(start-int, end-int, passnum-int, up/down-str, distance from RE-int, sequence-str) FOR EVERY OLIGO

#----FIRST AND SECOND PASS---------------------------------------------------------
#Scanning each MboI restriction site for the closest upstream and downstream oligos
#Either pass 1 or pass 2 criteria (see function get_pass_parameters)
# - Upstream oligos must not include upstream MboI sites
# - Downstream oligos must not include downstream MboI sites

RElocation = 0
search_start = 0
while search_seq_unmasked.find(REcutseq, search_start) != -1:
    RElocation = search_seq_unmasked.find(REcutseq, search_start)
    #------UPSTREAM OLIGOS------
    U_oligo = get_oligo_up(search_seq, search_start-1, RElocation, 1)
    if U_oligo[0] != "NONE":
        oligo_info = get_oligo_info(RElocation, U_oligo, 1, "U")
        info.append(oligo_info)
        
        print(oligo_info)
        
    else:
        U_oligo = get_oligo_up(search_seq, search_start-1, RElocation, 2)
        if U_oligo[0] != "NONE":
            oligo_info = get_oligo_info(RElocation, U_oligo, 2, "U")
            info.append(oligo_info)
            
            print(oligo_info)
            
    #------DOWNSTREAM OLIGOS------
    next_RElocation = search_seq_unmasked.find(REcutseq, RElocation+1)
    D_oligo = get_oligo_down(search_seq, RElocation, next_RElocation, 1)
    if D_oligo[0] != "NONE":
        oligo_info = get_oligo_info(RElocation, D_oligo, 1, "D")
        info.append(oligo_info)
        
        print(oligo_info)
        
    else:
        D_oligo = get_oligo_down(search_seq, RElocation, next_RElocation, 2)
        if D_oligo[0] != "NONE":
            oligo_info = get_oligo_info(RElocation, D_oligo, 2, "D")
            info.append(oligo_info)
            
            print(oligo_info)
            
    search_start = RElocation + 1

info = remove_overlapping_oligos(get_unique_oligos(info)) #Make unique and remove overlapping oligos

#----THIRD PASS--------------------------------------------------------------------
#Finding gaps in probe coverage > 110bp, then within each gap:
#Finding closest oligos on either side of any MboI site, using pass 3 criteria
# - Upstream oligos must not include upstream MboI sites
# - Downstream oligos must not include downstream MboI sites
# - New oligos CANNOT overlap oligos found in pass 1 or pass 2 or each other

new_oligo_info = []
RElocation = 0
for i in range(-1, len(info)):
    if i < 0:
        this_oligo_end = 0
    elif i >= 0:
        this_oligo_end = info[i][1]
    if i == len(info)-1:
        next_oligo_start = len(search_seq)-5
    elif i < len(info)-1:
        next_oligo_start = info[i+1][0]
    if (next_oligo_start - this_oligo_end) > 110:
        if i < 0:
            search_start = this_oligo_end
        else:
            search_start = this_oligo_end + 1
        search_end = next_oligo_start + 4
        while search_seq_unmasked.find(REcutseq, search_start, search_end) != -1:
            RElocation = search_seq_unmasked.find(REcutseq, search_start, search_end)
            #------UPSTREAM OLIGOS------
            U_oligo = get_oligo_up(search_seq, search_start, RElocation, 3)
            if U_oligo[0] != "NONE":
                oligo_info = get_oligo_info(RElocation, U_oligo, 3, "U")
                new_oligo_info.append(oligo_info)
            
                print(oligo_info)
            #------DOWNSTREAM OLIGOS------
            next_RElocation = search_seq_unmasked.find(REcutseq, RElocation+1, search_end)
            if next_RElocation == -1:
                next_RElocation = search_end - 4
            D_oligo = get_oligo_down(search_seq, RElocation, next_RElocation, 3)
            if D_oligo[0] != "NONE":
                oligo_info = get_oligo_info(RElocation, D_oligo, 3, "D")
                new_oligo_info.append(oligo_info)
            
                print(oligo_info)
            search_start = RElocation + 1

info.extend(new_oligo_info) #add new indexes to list
info = remove_overlapping_oligos(get_unique_oligos(info))


#----FOURTH PASS-------------------------------------------------------------------
#Finding regions where 5 oligos span more than 5kb, then within each region:
#Finding gaps of > 110bp, then within each gap:
#Finding closest oligos on either side of any MboI site, using pass 4 criteria
# - Upstream oligos must not include upstream MboI sites
# - Downstream oligos must not include downstream MboI sites
# - New oligos CANNOT overlap oligos found in pass 1 or pass 2 or pass 3

new_oligo_info =[]
RElocation = 0

scan_complete = False
placeholder = 0
while scan_complete == False:
    search_result = fourth_pass_scan(search_seq, search_seq_unmasked, REcutseq, info, placeholder)
    if search_result[0] != "NONE":
        info.append(search_result[0])
        info = get_unique_oligos(info)
    placeholder = search_result[2]
    scan_complete = search_result[1]
info = remove_overlapping_oligos(get_unique_oligos(info))

#-----------------------------------------------------------------------------------------------------------------
# PRINT CHROMOSOME ADDRESSES
#-----------------------------------------------------------------------------------------------------------------

chr_addresses_file = region_num + "oligo_chr_addresses.bed"
with open(chr_addresses_file, 'w') as write_chr_addresses:
    for ind in info:
        oligo_address_start = eval(chr_start) + ind[0] - 1
        oligo_address_end = eval(chr_start) + ind[1]
        write_chr_addresses.write(chromosome + "\t" + str(oligo_address_start) + "\t" + str(oligo_address_end) + "\t" + ("O_"+str(info.index(ind)+1)) + "\t1" + "\t+" + "\n")
write_chr_addresses.close()

print("\n\n---Found " + str(len(info)) + " oligos. Oligo coordinates located in: " + chr_addresses_file +"\n\n")

bed_oligos = pybedtools.BedTool( chr_addresses_file)
fasta_oligos = bed_oligos.sequence(fi=hg19fa)
lines = open(fasta_oligos.seqfn).readlines()

oligo_sequences_file = region_num + "oligo_sequences.fa"
with open(oligo_sequences_file, 'w') as write_oligo_sequences:
	for line in lines:
        	write_oligo_sequences.write(line)

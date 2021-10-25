# OCAML implementation of DFS & 1 iteration of Ford–Fulkerson Correction #

Note: Before testing out this project please ensure you have ocaml correctly 
installed

1. Enter your terminal and navigate to the schedulingInterviews directory
2. **run** dune build schedulingInterviews.ml (Generates the _build folder)
3. **run** dune exec ./schedulingInterviews.exe (Generates the _build folder)
4. You should now see that the terminal is waiting to accept stdin, expected
example input and output is below in the readme.  Copy paste the input into
your terminal
<br />
The time complexity for the algorithm is O(m) where m is the number of pairs 
of candidate and recruiter who could interview the candidate.
<br />

**Input (No Case)**<br />
5 5<br />
5 6<br />
5 7 8 9<br />
5 7 9<br />
5 7 8 9<br />
5 6 9<br />
0 1 3 0 0<br />
6 7 7 7<br />

**Output (No Case)**<br />
No<br />
1 1 0 0 1<br />

## Input Explanation<br />
You have n job candidates and k<=n recruiters.  The first line of input is n 
and k such that in the above example n=5 (we have 5 job candidates) and
k=5 (we have 5 job interviewers).

There are restrictions on which candidates the recruiters can interview. That
is denoted by lines 2 through (2+n).  In the above examples it is these lines:<br />
5 6<br />
5 7 8 9<br />
5 7 9<br />
5 7 8 9<br />
5 6 9<br />
Candidate 1 can be interviewed by recruiter 5 & 6. Candidate 2 can be
interviewed by 5, 7, 8, & 9, etc.

The second to last line denotes the total number of candidates a recruiter can
interview (their capacity):<br />
0 1 3 0 0<br />
Recruiter 5 can interview 0 people.  Recruiter 6 can interview 1 person.

The final line denotes the current matching which is always 1 fails to match 
the (n-1) candidate:<br />
6 7 7 7<br />
Candidate 1 is interviewed by recuiter 6. Candidate 2 is interviewed by 
recruiter 7.  Candidate (n+k) never has an interviewer.

## Output Explanation<br />
If there exists a full assignment of recruiters to candidates, the first line
will output "Yes" and the second line with output the matching.  If no possible
assignment exists, the first line with output "No" and the second line will be
a list of 1s and 0s denoting which recuiters capacities can be increase in order
to allow a full assignment.  Below is a Yes case example.

**Input (Yes Case)**<br />
5 5<br />
5 7 8<br />
5 8<br />
7 8 9<br />
5 6 8 9<br />
5 6 7 8<br />
0 1 0 2 2<br />
8 8 9 9<br />

**Output (Yes Case)**<br />
Yes<br />
8 8 9 9 6<br />
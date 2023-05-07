vetor1 = ['a':'z','A':'Z'];
vetor2 = ['a':'z'];
quatro_args = gerador_chaves(1e5,6,20,vetor);

probs = load('prob_pt.txt')

cinco_args = gerador_chaves(1e7,6,20,vetor2,probs);
length(unique(cinco_args))
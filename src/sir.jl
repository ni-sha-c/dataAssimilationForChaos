for k = 1:K
    for i = 1: N_p 
	    w[i] = w[i]*
    end
    sumw = sum(w)
	w ./= sum(w)
	N_eff = 1.0/sum(w.*w)
    if (N_eff < N_thr)
	    #resample
        for j = 1:N_p
			r = rand()
			cdfw = cumsum(w)
			new_pts[j] = 1
			for i = 1:N_p
		    	if cdfw[i] >= r
				    new_pts[j] = i
			        break
			    end
		    end

		end

						



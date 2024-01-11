function quan_sig = quan_uni(sig,q)
     for i = 1:length(sig)
         quan_sig(i) = quant(sig(i),q);
         d = sig(i) - quan_sig(i);
         if d == 0
             quan_sig(i) = quan_sig(i) + q/2;
             elseif (d > 0) && (abs(d) < q/2)
             quan_sig(i) = quan_sig(i) + q/2;
             elseif (d > 0) && (abs(d) >= q/2)
             quan_sig(i) = quan_sig(i) - q/2;
             elseif (d < 0) && (abs(d) < q/2)
             quan_sig(i) = quan_sig(i) - q/2;
             elseif (d < 0) && (abs(d) >= q/2)
             quan_sig(i) = quan_sig(i) + q/2;
         end
     end
end
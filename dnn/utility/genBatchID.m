function batchid = genBatchID(datasize,fixnum)

ndata = datasize;
nbatch = ceil(ndata/fixnum);

batchid = zeros(2,nbatch);
for ii = 1:nbatch    
    first = (ii-1)*fixnum+1;
    last = ii*fixnum;
    
    batchid(1,ii) = first;
    if last <= ndata
        batchid(2,ii) = last;
    else
        batchid(2,ii) = ndata;
    end    
end

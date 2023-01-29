%% construct a cload of points that is a cell with fixed size
function SensCS=SensCS(a,R,L)
    temp=1;
    for k=1/1000:1/1000:L
        for i=1/1000:1/1000:R
            for j=1/1000:1/1000:R   
                coef = ((R*1000-1)/2+1)/1000;
                SensCS1.chanpos(temp,:)=[a+(k-1/1000),i-coef,j-coef];
                SensCS1.coilpos(temp,:)=[a+(k-1/1000),i-coef,j-coef];
                SensCS1.chanori(temp,:)=[1,0,0];
                SensCS1.coilori(temp,:)=[1,0,0];
                SensCS1.chanunit{1,temp}='T';
                SensCS1.chantype{temp,1}='megmag';
                SensCS1.label{1,temp}=sprintf('chan%03d', temp);
                temp=temp+1;
            end        
        end
    end
    SensCS1.unit='m';
    SensCS=SensCS1;
end
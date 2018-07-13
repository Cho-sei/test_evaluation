global Input_filename = "0507_pretest";
global orderstim = load('stimorder_urethaneEEG.csv');

function evaluation(block)

  #----extract--------------------------
  global Input_filename;  
  
  filename = strcat(Input_filename,block);
  Fullname = strcat(filename,'.csv');

  Input_file = csvread(Fullname,0,1);

  Tri = Input_file(:,1);
  Res = Input_file(:,2);

  T = gradient(Tri);
  R = gradient(Res);

  Ind = find(T > 20);

  Index = Ind(1);
  R_vector = [];
  for i=1:length(Ind)-1
    offset = Ind(i+1)-Ind(i);
    if(offset > 2000)
      R_Check = R(Index:Ind(i+1)-1);
      Response = find(R_Check > 1000);
      if(isempty(Response)==1)
        R_vector = [R_vector; 0];
      else
        R_vector = [R_vector; Response(1)];
      endif
    Index = Ind(i+1);
    endif
  endfor

  R_Check = R(Index:length(Ind));
  Response = find(R_Check > 1000);
  if(isempty(Response)==1)
    R_vector = [R_vector; 0];
  else
    R_vector = [R_vector; Response(1)];
  endif



  #--------Accracy----------------------------------
  global orderstim;

  order = orderstim(:,1);

  #b1
  Pushmiss = Visualmiss = Auditrymiss = 0;
  for k=1:length(order)
    if(order(k) == 0)
      if(R_vector(k) != 0)
        Pushmiss++;
      endif
    elseif(order(k) == 1)
      if(R_vector(k) == 0)
        Visualmiss++;
      endif
    else
      if(R_vector(k) == 0)
        Auditrymiss++;
      endif
    endif
  endfor

  Visual = ((length(order) * 0.1) - Visualmiss) / (length(order) * 0.1);
  Auditry = ((length(order) * 0.1) - Auditrymiss) / (length(order) * 0.1);

  Accuracy_b1 = [Visual; Auditry];

  outputfile = [order R_vector];

  csvwrite(strcat(filename,'_Response.csv'),outputfile);

end

evaluation("_b1");
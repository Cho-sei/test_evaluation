Input_filename = "0507_pretest";
order = load('stimorder_urethaneEEG.csv');

#----BLOCK1-------------------------------------

filename_b1 = strcat(Input_filename,'_b1');
Fullname = strcat(filename_b1,'.csv');

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

R_vector_b1 = R_vector;

#----BLOCK2-------------------------------------

filename_b2 = strcat(Input_filename,'_b2');
Fullname = strcat(filename_b2,'.csv');

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

R_vector_b2 = R_vector;

#--------Accracy----------------------------------

order_b1 = order(:,1);
order_b2 = order(:,2);

#b1
Pushmiss = Visualmiss = Auditrymiss = 0;
for k=1:length(order_b1)
  if(order_b1(k) == 0)
    if(R_vector_b1(k) != 0)
      Pushmiss++;
    endif
  elseif(order_b1(k) == 1)
    if(R_vector_b1(k) == 0)
      Visualmiss++;
    endif
  else
    if(R_vector_b1(k) == 0)
      Auditrymiss++;
    endif
  endif
endfor

#Push = (length(order_b1) * 0.8) - Pushmiss;
Visual = ((length(order_b1) * 0.1) - Visualmiss) / (length(order_b1) * 0.1);
Auditry = ((length(order_b1) * 0.1) - Auditrymiss) / (length(order_b1) * 0.1);

Accuracy_b1 = [Visual; Auditry];

#b2
Pushmiss = Visualmiss = Auditrymiss = 0;
for k=1:length(order_b2)
  if(order_b2(k) == 0)
    if(R_vector_b2(k) != 0)
      Pushmiss++;
    endif
  elseif(order_b2(k) == 1)
    if(R_vector_b2(k) == 0)
      Visualmiss++;
    endif
  else
    if(R_vector_b2(k) == 0)
      Auditrymiss++;
    endif
  endif
endfor

Push = (length(order_b1) * 0.8) - Pushmiss;
Visual = ((length(order_b1) * 0.1) - Visualmiss) / (length(order_b1) * 0.1);
Auditry = ((length(order_b1) * 0.1) - Auditrymiss) / (length(order_b1) * 0.1);

Accuracy_b2 = [Visual; Auditry];

outputfile_b1 = [order_b1 R_vector_b1];
outputfile_b2 = [order_b2 R_vector_b2];

csvwrite(strcat(filename_b1,'_Response.csv'),outputfile_b1);
csvwrite(strcat(filename_b2,'_Response.csv'),outputfile_b2);

Accuracy = [Accuracy_b1 Accuracy_b2];
csvwrite(strcat(Input_filename,'_Result.csv'),Accuracy);

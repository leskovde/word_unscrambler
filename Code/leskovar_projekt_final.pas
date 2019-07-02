program leskovar_projekt_final;
// Program pouziva hashovaci tabulku, kolize resi spojovym seznamem
// Deklarace spojoveho seznamu
type PNode = ^TNode;
     TNode = record
       Value: ShortString;
       Next: PNode;
     end;

var MainArray: array[0..99] of PNode;
    Node1, Node2: PNode;
    Load: ShortString;
    i, n, index: byte;
    sum: integer;
    token, avail, fail: boolean;
    TextFile: text;

function Hash(Word: string): byte;
begin
  // Hashovani -> soucet ascii kodu vsech znaku stringu mod velikost pole
  sum:= 0;
  for i:= 1 to length(Word) do
  begin
    if ord(Word[i]) = 0 then break;
    sum:= sum + ord(Word[i]);
  end;
  Hash:= sum mod 100;
end;

procedure InsertIntoTable(Word: string; Position: byte);
begin
  // Hashovaci tabulka je pole s nody -> postup jako u spojovych seznamu
  new(Node1);
  // Pokud je seznam prazdny, spojime pointer z pole s novym nodem
      if MainArray[Position] = nil then
      begin
        MainArray[Position] := Node1;
        Node1^.Value:= Word;
        Node1^.Next:= nil;
      end
      else
  // Pokud uz seznam existuje, dojdeme nakonec a spojime ho s novym nodem
      begin
        Node2:= MainArray[Position];
        while Node2^.Next <> nil do
          Node2:= Node2^.Next;
        Node2^.Next:= Node1;
        Node1^.Value:= Word;
        Node1^.Next:= nil;
      end;
end;

procedure WriteList;
  // Pro testovani
begin
  writeln('Vypis seznamu');
  for i:=0 to 99 do
  begin
    Node1:= MainArray[i];
    while Node1 <> nil do
    begin
      writeln('Index ', i, ' ',Node1^.Value);
      Node1:= Node1^.Next;
    end;
  end;
end;

begin
  writeln('Press "1" to use the Console.');
  writeln('Press "2" to link a Text File.');
  writeln;
  write('Choose the input method: ');
  readln(Load);
  // Telo cyklu zajistujiciho navrat
  while true do
  begin
    writeln;
  // Vetev pro textovy vstup
    if Load = '2' then
    begin
      writeln('Please, ensure that the Text File is in the same folder as the executable of this program.');
      writeln;
      writeln('In this case, each line is considered a word. Please, make sure that the file is formatted accordingly.');
      writeln;
      write('File name (excluding the ".txt" extension): ');
      readln(Load);
      Load:= concat(Load,'.txt');
  // Inicializace textoveho souboru
      assignfile(TextFile, Load);
      try
        Reset(TextFile);
        while not eof(TextFile) do
        begin
          readln(TextFile, Load);
  // Hashovani
          index:= Hash(Load);
  // Vlozeni slova do node
          InsertIntoTable(Load, index);
        end;
        close(TextFile);
      except
        writeln;
        writeln('File Error! File not found. The program will now terminate.');
        readln;
        exit;
      end;
    end
  // Konec vetve pro textovy vstup
  // Vetev pro konzolovy vstup
    else if Load = '1' then
    begin
  // Zacatek vytvareni slovniku
      writeln('Please type the Dictionary entries one on each line, separate using "Enter".');
      writeln;
      writeln('Once you are complete with the Dictionary, type "-1" as a separate entry to exit.');
      writeln;
      while true do
      begin
        readln(Load);
        if Load = '-1' then break;
  // Hashovani
        index:= Hash(Load);
  // Vlozeni slova do node
        InsertIntoTable(Load, index);
      end;
    end
  // Konec vetve pro textovy vstup
  // Vetev pro nespravy vyber
    else
    begin
      writeln('Wrong Key! The program will now terminate.');
      readln;
      exit;
    end;
  // Konec vetve pro nespravny vyber
  // Konec vytvareni slovniku
  // Zde je dobre misto pro  WriteList;
  // Zadani hledaneho slova
    while true do
    begin
      writeln;
      write('Riddle me this: ');
      readln(Load);
  // Hashovani
      index:= Hash(Load);
      Node1:= MainArray[index];
      writeln;
      writeln('Results:');
      fail:= true;
      while Node1 <> nil do
      begin
  // Srovnavaci algoritmus
        if length(Load) = length(Node1^.Value) then
        begin
  // avail := flag pro cele slovo - pokud nekdy chybi token -> konec
          avail:= false;
          for i:=1 to length(Load) do
          begin
  // token := flag pro pismeno - pokud nektere chybi -> konec
            token:= false;
            for n:=1 to length(Node1^.Value) do
            if Load[i] = Node1^.Value[n] then token:= true;
            if token = true then avail:= true else avail:= false;
          end;
        end;
        if avail = true then
        begin
          writeln(Node1^.Value);
          fail:= false;
        end;
        Node1:= Node1^.Next;
      end;
  // fail := flag pro uspesnost hledani
      if fail = true then writeln('No Words Found.');
  // Telo cyklu pro volbu uzivatele
      while true do
      begin
        writeln;
        writeln('What now?');
        writeln('Press "1" to add more words to the dictionary.');
        writeln('Press "2" to search for another word.');
        writeln('Press "0" to exit.');
        write('Choose your next action: ');
        readln(Load);
        if (Load <> '1') and (Load <> '2') and (Load <> '0') then
        begin
          writeln;
          writeln('Wrong Key! Try again.')
        end
        else break;
      end;
      if Load = '0' then exit;
      if Load <> '2' then break;
    end;
  // Pokud jsme tady, jdeme zpatky na zacatek
  end;
end.


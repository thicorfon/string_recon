defmodule StringRecon do
  def getDistincts([]) do
    []
  end

  def getDistincts([head|tail])do
    if inList(head,tail) == true do
      getDistincts(tail)
    else
      [head|getDistincts(tail)]
    end
  end

	def inList(_, []) do
		false
	end

  def inList(member, [head|tail]) do
    if member == head do
      true
    else
      inList(member, tail)
    end
  end

  def appendList([],list) do
    list
  end

  def appendList([head|tail], list) do
    [head|appendList(tail,list)]
  end

  def derivate(_,[]) do
    []
  end

  def derivate(char, relations) do
    [headRelations|tailRelations] = relations
    {origem,destino} = headRelations
    if char == origem do
      [destino|derivate(char, tailRelations)]
    else
      derivate(char, tailRelations)
    end
  end

  def derivatedStrings([],_, _, _) do
    []
  end


  def derivatedStrings(listaDeDerivadas, tailString, size , seen) do #dada uma lista de resultado de derivadas, e o resto de uma string, retorna uma lista c
      [headDerivadas|tailDerivadas] = listaDeDerivadas
      stringCompleta = appendList(seen,appendList(headDerivadas,tailString))
      if length(stringCompleta) > size do
        derivatedStrings(tailDerivadas,tailString,size, seen)
      else
        [stringCompleta|derivatedStrings(tailDerivadas,tailString,size,seen)]
      end 
  end

  def applyRelations(a,b,c,seen \\ [])

  def applyRelations([], _, _, _) do
    []
  end 

  def applyRelations(stringAuxiliar, grammar, size, seen) do # retorna todas as strings derivadas para uma determinada string (SÓ DERIVA UM NÃO TERMINAL POR VEZ)
    [nonterminals,_,_,relations] = grammar
    [headString | tailString] = stringAuxiliar # ['a','B']
    if inList(headString,nonterminals) do
      listaDeDerivadas = derivate(headString,relations)
      listaDeStringsDerivadas = derivatedStrings(listaDeDerivadas,tailString, size, seen)
      appendList(listaDeStringsDerivadas,applyRelations(tailString, grammar, size,(seen++[headString])))
    else
      applyRelations(tailString, grammar, size,(seen++[headString]))
    end 
  end

  def generateStrings([], _ ,_) do
    []
  end

  def generateStrings(current, grammar, size) do
  	#[nonterminals,terminals,start,relations] = grammar
    #current = lista de strings
    [headCurrent|tailCurrent] = current #headCurrent é string
    generatedStrings = applyRelations(headCurrent,grammar,size)
    currentStrings = appendList(generatedStrings,tailCurrent)
    [headCurrent|generateStrings(currentStrings, grammar, size)]
  end

  def isTerminalString([],_) do
    true
  end

  def isTerminalString([headChar|tailChar], terminals) do
    if inList(headChar,terminals) do
      isTerminalString(tailChar,terminals)
    else
      false
    end
  end

  def getOnlyValidStrings([],_) do
    []
  end

  def getOnlyValidStrings([headString|tailStrings],terminals) do
    if isTerminalString(headString,terminals) do
      [headString|getOnlyValidStrings(tailStrings,terminals)]
    else
      getOnlyValidStrings(tailStrings,terminals)
    end
  end

  def generateValidStrings(current, grammar, size) do
    [_,terminals,_,_] = grammar
    getOnlyValidStrings(getDistincts(generateStrings(current,grammar,size)),terminals)
  end

  def stringRecon(string, grammar) do 


  # string = ['a', :b, 'T', 312], string composta somente de terminais
  # nonterminals = [coisas] ['A' , 'B', 'S']
  # terminais = [coisas] ['a','b']
  # start = coisa, sendo coisa pertencente a nonterminals 'S' 
  # relations = [relation] [{'S',['b','S','A']}, {'A',['a']}]
  # relation = {origem, destino} {'S',['b','S','A']} 'S' -> ['b','S','A']
  # origem = nonterminal 'S'
  # destino = string_auxiliar ['b','S','A']
  # string_auxiliar = [nonterminals*terminals] ['b','S','A']
  
    [_,_,start,_] = grammar
    generated = generateValidStrings([[start]],grammar,length(string))
    if inList(string,generated) do
      true
    else 
      false
    end 
  end

end



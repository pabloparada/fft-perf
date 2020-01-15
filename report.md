## Configurações de Hardware

- Processador AMD Ryzen 7 2700 3.2 GHz 20MB Cache AM4
- 2X Memória Patriot Viper 8GB DDR4 2666MHz
- SSD Crucial BX500 480GB

## Nomenclatura

Neste relatório quando citamos "frequências" estamos se referindo a 1Khz ou 1024hz (para manter a base 2) , ou seja, se o número de frequencias geradas for de 10 então estamos falando de 10Khz.

## Dados

Cada aplicação gera seus próprios dados utilizando a função seno tendo como parâmetro um numeral randômico e então escalado para o intervalo [-400, 400].

## Node Profiling

O `script` em `nodejs` foi executado de modo que gerasse o número de frequencias necessarias para validar tanto o consumo de memória como o tempo de execução. Além disso, este `script` foi apresentado no formato em que se é gerado as frequencias de antemão e onde é usado cache de frequências.

### Execução Gerando Frequencias

##### Execução Completa
|Número de Frequencias|Execução|Tempo (ms)|Tempo (s)|Tempo Médio (ms)|Memoria RSS (MB)|Memoria HPT (MB)| Memoria HP (MB)| Memoria EXT (MB)|
|---------------------|--------|----------|---------|----------------|----------------|----------------|----------------|-----------------|
|600                  |1	   |657.50    |65.75    |1,09            |168,87          |134,19          |109.02          |0,87             |
|600                  |2	   |701.75    |70.17    |1,16            |169,58          |137.71          |108.74          |0,87             |
|600                  |3	   |673.97    |67.39    |1,12            |168,81          |134.45          |108.95          |0,87             |
|600                  |4	   |680.75    |68.07    |1,13            |168,81          |134.71          |109.33          |0,87             |
|600                  |5	   |676.31    |67.63    |1,12            |169,25          |134.45          |109.71          |0,87             |

###### Legenda

- RSS (Resident Set Size): total de memória alocada para o processo em questão
- HPT (Heap Total): tamanho total da memória heap alocada
- HP (Heap): memória utilizada durante a execução do processo
- EXT: memória utilizada pelo V8

##### Execução por Operação
|Operação |Número de Frequencias|Execução|Tempo (%)|
|---------|---------------------|--------|---------|
|FFT      |10                   |1		 |48.6     |
|RUN_LAZY |10                   |1       |03.4     |
|MALLOC   |10                   |1		 |01.4     |
|FFT      |10                   |2		 |49.7     |
|RUN_LAZY |10                   |2       |02.7     |
|FFT      |10                   |3		 |47.6     |
|RUN_LAZY |10                   |3       |02.8     |
|FFT      |10                   |4		 |54.8     |
|RUN_LAZY |10                   |4       |01.6     |
|MEMCPY   |10                   |1		 |02.4     |
|FFT      |10                   |5		 |52.0     |
|RUN_LAZY |10                   |5       |02.6     |

> Esta tabela contém o tempo de CPU em porcentagem de funções executadas a partir da chamada da função para calculo FFT, ou seja, tendo a primeira execução como base por si só a função FFT (fftInPlace) custou 48.6% de execução, além de ter sido compilada pela função principal (run) gastando 3.4% na sua primeira execução.

### Execução Frequencia Cacheada

##### Execução Completa
|Número de Frequencias|Execução|Tempo (ms)|Tempo (s)|Tempo Médio (ms)|Memoria RSS (MB)|Memoria HPT (MB)| Memoria HP (MB)| Memoria EXT (MB)|
|---------------------|--------|----------|---------|----------------|----------------|----------------|----------------|-----------------|
|600                  |1	   |2450.35   |02.45    |4,08            |68,36           |38,24           |06,90           |0,87             |
|600                  |2	   |2439.92   |02.43    |4,06            |68,50           |37.98           |16.59           |0,87             |
|600                  |3	   |2505.58   |02.50    |4,17            |67,98           |38.24           |82.85           |0,87             |
|600                  |4	   |2463.00   |02,63    |4,10            |68,91           |38.24           |42.96           |0,87             |
|600                  |5	   |2449.30   |02,44    |4,08            |69,08           |37.98           |19.97           |0,87             |

###### Legenda

- RSS (Resident Set Size): total de memória alocada para o processo em questão
- HPT (Heap Total): tamanho total da memória heap alocada
- HP (Heap): memória utilizada durante a execução do processo
- EXT: memória utilizada pelo V8

##### Execução por Operação
|Operação |Número de Frequencias|Execução|Tempo (%)|
|---------|---------------------|--------|---------|
|FFT      |10                   |1		 |57.9     |
|MALLOC   |10                   |1		 |01.0     |
|MEMCPY   |10                   |1		 |01.0     |
|RUN_LAZY |10                   |1       |04.6     |
|FFT      |10                   |2		 |64.0     |
|PTHREAD  |10                   |2		 |01.2     |
|RUN_LAZY |10                   |2       |03.7     |
|FFT      |10                   |3		 |66.0     |
|RUN_LAZY |10                   |3       |06.8     |
|FFT      |10                   |4		 |66.0     |
|RUN_LAZY |10                   |4       |05.7     |
|FFT      |10                   |5		 |65.7     |
|RUN_LAZY |10                   |5       |02.4     |

> Esta tabela contém o tempo de CPU em porcentagem de funções executadas a partir da chamada da função para calculo FFT, ou seja, tendo a primeira execução como base por si só a função FFT (fftInPlace) custou 57% de execução, gerando 1% em MALLOC e MEMCPY respectivamente, além de ter sido compilada pela função principal (run) gastando 4.6% na sua primeira execução.


## Lua Profiling

O `script` em `lua`, assim como o de `nodejs` foi executado em diferentes modos afim de obter uma média dos recursos utilizados. Abaixo serão listados os respectivamente os valores obtidos:

### Execução Gerando Frequencias

##### Execução Completa
|Número de Frequencias|Execução|Tempo (ms)|Tempo (s)|Tempo Médio (ms)|Memoria (MB)|Memoria (Bytes)|
|---------------------|--------|----------|---------|----------------|------------|---------------|
|600                  |1	   |6850.10   |6,8      |11.41           |41.91       |41911793       |
|600                  |2	   |6483.81   |6.4      |10.80           |40.83       |40835855       |
|600                  |3	   |6471.56   |6.4      |10.78           |40.67       |40674543       |
|600                  |4	   |6466.26   |6.4      |10.77           |40.83       |40836583       |
|600                  |5	   |6485.19   |6.4      |10.80           |40.83       |40836583       |


##### Execução por Operação
|Operação    |Número de Frequencias|Execução|Tempo (%)|
|------------|---------------------|--------|---------|
|FFT	     |10                   |1		|28.57    |
|GEN	     |10                   |1		|99.78    |
|GEN_COMPLEX |10                   |1		|79.95    |
|GEN_TABLE   |10                   |1		|9.99     |
|FFT	     |10                   |2		|28.57    |
|GEN	     |10                   |2		|99.78    |
|GEN_COMPLEX |10                   |2		|79.95    |
|GEN_TABLE   |10                   |2		|9.99     |
|FFT	     |10                   |3		|28.57    |
|GEN	     |10                   |3		|99.69    |
|GEN_COMPLEX |10                   |3		|79.70    |
|GEN_TABLE   |10                   |3		|9.96     |
|FFT	     |10                   |4		|28.57    |
|GEN	     |10                   |4		|99.69    |
|GEN_COMPLEX |10                   |4		|79.70    |
|GEN_TABLE   |10                   |4		|9.96     |
|FFT	     |10                   |5		|28.57    |
|GEN	     |10                   |5		|99.78    |
|GEN_COMPLEX |10                   |5		|79.95    |
|GEN_TABLE   |10                   |5		|9.99     |

> A tabela de Execução por Operação acima foi gerada com 10 operações pois o profiler callgrind utiliza muitos recursos para gerar suas métricas.

As operações acima possuem o seguinte significado:

- FFT: execução da função de cálculo de FFT através da LIBFFTW3;
- GEN: geração de frequencias;
- GEN_COMPLEX: alocação de números complexos para cada frequencia;
- GEN_TABLE: alocação de tabelas lua para geraçõa de frequencias;

### Execução Frequencia Cacheada

##### Execução Completa
|Número de Frequencias|Execução|Tempo (ms)|Tempo Médio (ms)|Memoria (MB)|Memoria (Bytes)|
|---------------------|--------|----------|----------------|------------|---------------|
|600                  |1	   |73.02     |0.12            |0,252963    |252963         |
|600                  |2	   |40.86     |0,06            |0,252973    |252973         |
|600                  |3	   |71.18     |0,11            |0,252974    |252974         |
|600                  |4	   |67.43     |0,11            |0,252972    |252972         |
|600                  |5	   |64.01     |0,10            |0,252962    |252960         |


##### Execução por Operação
|Operação|Número de Frequencias|Execução|Tempo (%)|
|--------|---------------------|--------|---------|
|FFT	 |600                  |1		|14.14    |
|FFT	 |600                  |2		|14.14    |
|FFT	 |600                  |3		|14.14    |
|FFT	 |600                  |4		|14.14    |
|FFT	 |600                  |5		|14.14    |

> O tipo de operação GEN foi omitido pois com frequencias com cache o valor é desconsiderado.

As operações acima possuem o seguinte significado:

- FFT: execução da função de cálculo de FFT através da LIBFFTW3;
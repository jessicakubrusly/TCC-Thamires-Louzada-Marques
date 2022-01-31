# pt-BR

Este projeto foi criado com o objetivo de reunir os scripts e dados utilizados para o meu TCC. 

O objetivo do trabalho foi o de coletar um conjunto de dados do Twitter com base nas trending hashtags, e aplicar técnicas de mineração de textos e métodos de Machine Learning para classificação dos tweets como contrários ou favoráveis ao governo federal brasileiro atual. Os rótulos utilizados foram as próprias hashtags, mantidas somente quando possuíam claramente um posicionamento contrário ou favorável. 

## Os Scripts

Os scripts estão enumerados de acordo com a ordem que eles foram criados. Os iniciados por "00" são referentes a processos extra, sem ordem específica. 

- _00_classificationTreeExample.R_ gera um exemplo de árvores de classificação utilizado na apresentação com propósito lúdico; 
- _00_keptHashtags.R_ gera um arquivo .xlsx com as hashtags mantidas e o posicionamento delas (contrária/favorável ao governo); 
- _01_getTwitterData.R_ realiza a consulta aos dados do Twitter e mantém somente tweets com hashtags dos trending topics. Ele foi agendado para ser executado 3x por dia, ao longo de 3 meses; 
- _02_readSplitRawData.R_ lê os dados gerados e os agrupa em duas bases de dados por mês de coleta, totalizando 6 conjuntos de dados. Foi criado com o objetivo de disponibilizar os dados brutos de uma forma mais acessível; 
- _03_labelData.R_ lê os 6 conjuntos de dados agrupados, e gera uma opção para o usuário visualizar as hashtags uma a uma e escolher se ela deve ser mantida ou não, e qual seria o posicionamento dela perante ao governo. Gera 6 conjuntos de dados limpos; 
- _04_joinLabeledData.R_ lê os 6 conjuntos de dados limpos e com as hashtags selecionadas e os agrupa em um só, muito menor que os dados originais; 
- _05_trainTestSplit.R_ divide e salva os bancos de treino e de teste; 
- _06_preProcessing.R_ aplica todo o pré-processamento previsto nos dados textuais; 
- _07_exploratoryAnalysis.R_ realiza a análise exploratória dos dados textuais; 
- _08_classificationAlgorithms.R_ realiza o treinamento dos algoritmos de Machine Learning para classificação; 
- _09_predictions.R_ realiza as previsões e salva as métricas de comparação dos modelos; 
- _10_crossValidation.R_ gera dados para validação cruzada de todos os modelos treinados. 

## Os Dados

Não foi possível incluir todos os conjuntos de dados no repositório, pois alguns ultrapassavam o limite de 25MB, porém todos os arquivos que de fato eram necessários foram upados.

- _TrendingTopicsTwitterBrasil20210x_y.RData_ são os dados brutos, que foram agrupados por quinzena de modo a serem disponibilizados; 
- _0xdataclean.RData_ são os arquivos dos dados já somente com as hashtags com posicionamento claro perante ao governo selecionadas; 
- _GroupedCleanData.RData_ é o agrupamento dos arquivos _0xdataclean.RData_; 
- _TrainingSample.RData_ são os dados de treino; 
- _TestingSample.RData_ são os dados de teste; 
- _TermDocumentMatrix.RData_ contém dados da matriz termo-documento dos dados de treino; 
- _PreProcessingObjects.RData_ contém os objetos necessários para realizar o pré-processamento dos dados; 
- _Models.zip_ contém os modelos treinados. O arquivo .RData era muito grande, então foi comprimido em .zip; 
- _ValidationMetrics.RData_ contém as métricas de comparação dos modelos treinados com base nos resultados da amostra de teste; 
- _hashtags.xlsx_ descreve as hashtags claramente contrárias ou favoráveis ao governo que estavam contidas nos dados coletados; 
- _stopwords.xlsx_ possui a lista das stopwords utilizadas no pré-processamento; 
- _TermosMatrizTermoDoc.xlsx_ possui os termos contidos na matriz termo-documento final; 
- _ModelMetrics_Full.xlsx_ contém as métricas de validação dos modelos.





# en-US

This project was created in order to gather all the scripts and data used for my undergraduate thesis. 

The objective of this project was to collect a Twitter dataset based on the trending hashtags, and apply text mining techniques and Machine Learning methods to classify tweets as against or in favor of the current Brazilian federal government. The labels used were the hashtags themselves, kept only when they clearly had a contrary or favorable position.

## The Scripts

The scripts are enumerated according to the order they were created. The ones starting by "00" refer to extra processess, with no specific order. 

- _00_classificationTreeExample.R_ generates an example of classification trees used in the presentation for easier explanation;
- _00_keptHashtags.R_ generates a .xlsx file with the hashtags kept and their positioning (against/favorable to the government);
- _01_getTwitterData.R_ performs the query of Twitter data and keeps only the tweets with hashtags from the trending topics. It was scheduled to run 3 times a day for 3 months;
- _02_readSplitRawData.R_ reads the generated data and groups them into two databases per month, a total of 6 data sets. It was created with the aim of making raw data available in a more accessible way;
- _03_labelData.R_ reads the 6 grouped data sets, and generates an option for the user to view the hashtags one by one and choose whether or not they should be kept, and what their position towards the government should be. Generates 6 clean datasets;
- _04_joinLabeledData.R_ reads the 6 clean datasets with the selected hashtags and groups them into one, much smaller than the original data;
- _05_trainTestSplit.R_ splits and saves training and test databases;
- _06_preProcessing.R_ applies all the planned pre-processing in the textual data;
- _07_exploratoryAnalysis.R_ performs exploratory analysis of the textual data;
- _08_classificationAlgorithms.R_ trains Machine Learning algorithms for classification;
- _09_predictions.R_ performs the predictions and saves the comparison metrics of the models;
- _10_crossValidation.R_ generates data for cross validation of all trained models.

## The Data 

It was not possible to include all datasets in the repository, as some exceeded the 25MB limit, but all the files that were actually needed were uploaded.

- _TrendingTopicsTwitterBrasil20210x_y.RData_ the raw data, which were grouped by fortnight in order to be available;
- _0xdataclean.RData_ the data with only selected hashtags with clear positioning towards the government;
- _GroupedCleanData.RData_ the grouping of _0xdataclean.RData_ files;
- _TrainingSample.RData_ the training data;
- _TestingSample.RData_ the test data;
- _TermDocumentMatrix.RData_ contains data from the term-document matrix of training data;
- _PreProcessingObjects.RData_ contains the objects needed to preprocess the data;
- _Models.zip_ contains the trained models. The .RData file was too large, so it was compressed into .zip;
- _ValidationMetrics.RData_ contains the comparison metrics of the trained models based on the test sample results;
- _hashtags.xlsx_ describes the hashtags clearly against or in favor of the government that were contained in the collected data;
- _stopwords.xlsx_ the list of stopwords used during pre-processing;
- _TermosMatrizTermoDoc.xlsx_ the terms contained in the final term-document matrix;
- _ModelMetrics_Full.xlsx_ contains the model validation metrics.


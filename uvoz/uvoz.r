
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(rvest)


#slovar imen držav
slovar <- c("Belgium" = "Belgija",
            "Germany (until 1990 former territory of the FRG)" = "Nemčija",
            "Bulgaria" = "Bolgarija",
            "Czechia" = "Češka",
            "Czech Republic"="Češka",
            "Denmark" = "Danska",
            "Germany" = "Nemčija",
            "Estonia" = "Estonija",
            "Kosovo (under United Nations Security Council Resolution 124" = "Kosovo",
            "Ireland" = "Irska",
            "Greece" = "Grčija",
            "Spain" = "Španija",
            "France" = "Francija",
            "Croatia" = "Hrvaška",
            "Italy" = "Italija",
            "Cyprus" = "Ciper",
            "Latvia" = "Latvija",
            "Lithuania" = "Litva",
            "Luxembourg" = "Luksemburg",
            "Liechtenstein" = "Lihtenštajn",
            "Hungary" = "Madžarska",
            "Malta" = "Malta",
            "Moldova"="Moldavija",
            "Montenegro" ="Črna Gora",
            "Netherlands" = "Nizozemska",
            "Norway" = "Norveška",
            "Austria" = "Avstrija",
            "Albania"="Albanija",
            "Belarus"="Belorusija",
            "Bosnia and Herzegovina"="Bosna in Hercegovina",
            "Poland" = "Poljska",
            "Portugal" = "Portugalska",
            "Romania" = "Romunija",
            "Slovenia" = "Slovenija",
            "Slovakia" = "Slovaška",
            "Russia" = "Rusija",
            "Ukraine" = "Ukrajina",
            "Finland" = "Finska",
            "Sweden" = "Švedska",
            "Switzerland" = "Švica",
            "United Kingdom" = "Združeno kraljestvo (Velika Britanija)",
            "Iceland" = "Islandija",
            "North Macedonia" = "Severna Makedonija",
            "Kosovo" = "Kosovo",
            "San Marino" = "San Marino",
            "Serbia" = "Srbija",
            "Turkey" = "Turčija")

slovarspol <- c("Males" = "Moški", "Females" = "Ženske")
#__________________________TABELA 1________________
#število priseljenih iz držav, letno
imenastolpcev <- c("Leto", "Drzava", "Selitev", "Spol", "Priseljeni_iz_tujine")
tabela1 <- read_csv2("podatki/priseljeni_drzava_spol.csv", na=c("..."), col_names = imenastolpcev, skip=3,
                    locale=locale(encoding = "Windows-1250"))

tabela1$Selitev <- NULL

tabela1$Drzava[tabela1$Drzava == "AVSTRALIJA IN OCEANIJA"] <- "Avstralija in Oceanija"
tabela1 <- subset(tabela1, Drzava!="EVROPA")
tabela1 <- subset(tabela1, Drzava!="Slovenija")
tabela1 <- subset(tabela1, Drzava!="SEVERNA IN SREDNJA AMERIKA")
tabela1$Drzava[tabela1$Drzava == "AFRIKA"] <- "Afrika"
tabela1$Drzava[tabela1$Drzava == "AZIJA"] <- "Azija"
tabela1$Drzava[tabela1$Drzava == "JUŽNA AMERIKA"] <- "Južna Amerika"

#__________________________TABELA 2__________________
#število odseljenih, kam, letno
imenastolpcev2 <- c("Leto", "Drzava_prihodnjega_bivalisca", "Selitev", "Spol", "Odseljeni_v_tujino")
tabela2 <- read_csv2("podatki/odseljenidrzavaspol.csv", na=c("..."), col_names = imenastolpcev2, skip=3,
                     locale=locale(encoding = "Windows-1250"))

tabela2$Selitev <- NULL
tabela2 <- subset(tabela2, Spol!="Državljani Republike Slovenije - SKUPAJ")
tabela2 <- subset(tabela2, Drzava_prihodnjega_bivalisca!="EVROPA")
tabela2 <- subset(tabela2, Drzava_prihodnjega_bivalisca!="Slovenija")
tabela2$Spol[tabela2$Spol == "Državljani Republike Slovenije - moški"] <- "Moški"
tabela2$Spol[tabela2$Spol == "Državljani Republike Slovenije - ženske"] <- "Ženske"
tabela2 <- subset(tabela2, Drzava_prihodnjega_bivalisca!="SEVERNA IN SREDNJA AMERIKA")
tabela2$Drzava_prihodnjega_bivalisca[tabela2$Drzava_prihodnjega_bivalisca == "AFRIKA"] <- "Afrika"
tabela2$Drzava_prihodnjega_bivalisca[tabela2$Drzava_prihodnjega_bivalisca == "AZIJA"] <- "Azija"
tabela2$Drzava_prihodnjega_bivalisca[tabela2$Drzava_prihodnjega_bivalisca == "JUŽNA AMERIKA"] <- "Južna Amerika"
tabela2$Drzava_prihodnjega_bivalisca[tabela2$Drzava_prihodnjega_bivalisca == "AVSTRALIJA IN OCEANIJA"] <- "Avstralija in Oceanija"
tabela2 <- tabela2 %>% rename("Drzava"="Drzava_prihodnjega_bivalisca") 
#___________________________TABELA 3_______________________________________
#starotna skupina odseljenih tabela
imenastolpcev3 <- c("Leto", "Drzava", "Izobrazba", "Starost", "Spol", "Stevilo_odseljenih")
tabela3 <- read_csv2("podatki/odseljenistarost.csv", na=c("..."), col_names = imenastolpcev3, skip=3,
                     locale=locale(encoding = "Windows-1250"))
tabela3$Drzava <- NULL
tabela3$Izobrazba <- NULL

#_______________________TABELA 4_________________________________________
#tabela o stevilu priseljenih glede na starostno skupino
imenastolpcev4 <- c("Leto", "Drzavljanstvo", "Drzava", "Starost", "Stevilo_priseljenih")
tabela4 <- read_csv2("podatki/priseljeni_starost.csv", na=c("..."), col_names = imenastolpcev4, skip=3,
                     locale=locale(encoding = "Windows-1250"))
tabela4$Drzavljanstvo <- NULL
 
tabela4$Drzava <- gsub("\\.\\.\\.\\.","",tabela4$Drzava)

tabela4 <- subset(tabela4, Drzava!="- Države EU - SKUPAJ")
tabela4 <- subset(tabela4, Drzava!="- Druge evropske države - SKUPAJ")
tabela4$Drzava[tabela4$Drzava == "AFRIKA"] <- "Afrika"
tabela4$Drzava[tabela4$Drzava == "AZIJA"] <- "Azija"
tabela4$Drzava[tabela4$Drzava == "JUŽNA AMERIKA"] <- "Južna Amerika"
tabela4$Drzava[tabela4$Drzava == "AVSTRALIJA IN OCEANIJA"] <- "Avstralija in Oceanija"
tabela4$Drzava[tabela4$Drzava == "SEVERNA IN SREDNJA AMERIKA"] <- "Severna in Srednja Amerika"


#_______________________ Tabela 5 _______________________________________________
#tabela o izobrazbi odseljenih ljudi
imenastolpcev5 <- c("Leto", "Drzava_prihodnjega_bivalisca", "Drzavljanstvo", "Spol", "Izobrazba", "Stevilo_odseljenih")
tabela5 <- read_csv2("podatki/odseljeni_izobrazba.csv", na=c("..."), col_names = imenastolpcev5, skip=3,
                     locale=locale(encoding = "Windows-1250"))

tabela5 <- subset(tabela5, select = c("Leto",  "Drzava_prihodnjega_bivalisca", "Izobrazba","Spol", "Stevilo_odseljenih"))

tabela5$Drzava_prihodnjega_bivalisca <- gsub("\\.\\.\\.\\.","",tabela5$Drzava_prihodnjega_bivalisca)
tabela5 <- subset(tabela5, Drzava_prihodnjega_bivalisca!="Država prihodnjega prebivališča - SKUPAJ")
tabela5 <- subset(tabela5, Drzava_prihodnjega_bivalisca!="EVROPA - SKUPAJ")
tabela5 <- subset(tabela5, Drzava_prihodnjega_bivalisca!="- Države nastale na območju nekdanje Jugoslavije - SKUPAJ")
tabela5 <- subset(tabela5, Drzava_prihodnjega_bivalisca!="- Države EU - SKUPAJ")
tabela5 <- subset(tabela5, Drzava_prihodnjega_bivalisca!="- Druge evropske države - SKUPAJ")

tabela5$Drzava_prihodnjega_bivalisca[tabela5$Drzava_prihodnjega_bivalisca == "AFRIKA"] <- "Afrika"
tabela5$Drzava_prihodnjega_bivalisca[tabela5$Drzava_prihodnjega_bivalisca == "AZIJA"] <- "Azija"
tabela5$Drzava_prihodnjega_bivalisca[tabela5$Drzava_prihodnjega_bivalisca == "JUŽNA AMERIKA"] <- "Južna Amerika"
tabela5$Drzava_prihodnjega_bivalisca[tabela5$Drzava_prihodnjega_bivalisca == "AVSTRALIJA IN OCEANIJA"] <- "Avstralija in Oceanija"
tabela5$Drzava_prihodnjega_bivalisca[tabela5$Drzava_prihodnjega_bivalisca == "SEVERNA IN SREDNJA AMERIKA"] <- "Severna in Srednja Amerika"


#________________________________ TABELA 6 ___________________________________________
#tabela o številu priseljenih glede na izobrazbo
imenastolpcev6 <- c("Leto", "Drzava", "Drzavljanstvo", "Spol", "Izobrazba", "Stevilo")
tabela6 <- read_csv2("podatki/priseljeni_izobrazba.csv", na=c("..."), col_names = imenastolpcev6, skip=3,
                     locale=locale(encoding = "Windows-1250"))

tabela6$Drzavljanstvo <- NULL
tabela6 <- subset(tabela6, select = c("Leto", "Drzava","Izobrazba", "Spol", "Stevilo"))
tabela6$Drzava[tabela6$Drzava == "AFRIKA"] <- "Afrika"
tabela6$Drzava[tabela6$Drzava == "AZIJA"] <- "Azija"
tabela6$Drzava[tabela6$Drzava == "JUŽNA AMERIKA"] <- "Južna Amerika"
tabela6$Drzava[tabela6$Drzava == "AVSTRALIJA IN OCEANIJA"] <- "Avstralija in Oceanija"
tabela6$Drzava[tabela6$Drzava == "SEVERNA IN SREDNJA AMERIKA"] <- "Severna in Srednja Amerika"
tabela6 <- subset(tabela6, Drzava!="Država prejšnjega prebivališča - SKUPAJ")
tabela6 <- subset(tabela6, Drzava!="EVROPA - SKUPAJ")
tabela6 <- subset(tabela6, Drzava!="- Države nastale na območju nekdanje Jugoslavije - SKUPAJ")
tabela6 <- subset(tabela6, Drzava!="Države EU - SKUPAJ")
tabela6 <- subset(tabela6, Drzava!="- Druge evropske države")
tabela6$Drzava <- gsub("\\.\\.\\.\\.","",tabela6$Drzava)

#___________________ TABELA 7 ______________________________________________
#Tabela o namenu priseljencev v Slovenijo

imenastolpcev7 <- c("Leto", "Drzava", "Namen", "Stevilo")
tabela7 <- read_csv2("podatki/priseljeninamen.csv", na=c("...", "z"), col_names = imenastolpcev7, skip=3,
                     locale=locale(encoding = "Windows-1250"))
tabela7 <- tabela7 %>% filter(between(Leto,2011,2019))
tabela7 <- subset(tabela7, Drzava!="Neznano")
tabela7 <- subset(tabela7, Drzava!="Srbija in Črna gora")
tabela7 <- subset(tabela7, Drzava!="Države EU")
tabela7$Drzava[tabela7$Drzava == "... druge države članice EU"] <- "ostale države članice EU"

tabela7 <- tabela7[!(tabela7$Drzava=="Hrvaška" & tabela7$Leto>2013), ]
tabela7 <- tabela7[!(tabela7$Drzava=="... Hrvaška" & tabela7$Leto<=2013), ]
tabela7$Drzava <- gsub("... Hrvaška", "Hrvaška", tabela7$Drzava)

#tabela7$Drzava[tabela7$Drzava == "... Hrvaška"] <- "Hrvaškaa"
#novo <- tabela7 %>% filter(Drzava!="Hrvaška", Leto > 2013) 
#novo2 <- tabela7 %>% filter(Drzava!="Hrvaškaa",Leto<=2013) 
#tabela7zares <- bind_rows(novo,novo2)
#tabela7zares$Drzava[tabela7zares$Drzava == "Hrvaškaa"] <- "Hrvaška"

#___________________ TABELA 8 ___________________________________________________
# Priseljeni prebivalci po dejavnosti
imenastolpcev8 <- c("Leto", "Drzavljanstvo", "Spol", "Dejavnost", "Stevilo")
tabela8 <- read_csv2("podatki/priseljenipodejavnosti.csv", col_names = imenastolpcev8, skip=3,
                     locale=locale(encoding = "Windows-1250"))
  
tabela8 <- subset(tabela8, select = c("Leto", "Dejavnost","Spol", "Stevilo")) 
tabela8 <- arrange(tabela8,Leto, Dejavnost)
tabela8 <- subset(tabela8, Dejavnost!="Dejavnost eksteritorialnih organizacij in teles")
  
#______________ TABELA 9_____________________________________________________________
#Odseljeni prebivalci po dejavnosti
imenastolpcev9 <- c("Leto", "Drzavljanstvo", "Spol", "Dejavnost", "Stevilo")
tabela9 <- read_csv2("podatki/odseljenipodejavnosti.csv", col_names = imenastolpcev9, skip=3,
                     locale=locale(encoding = "Windows-1250"))
tabela9 <- subset(tabela9, select = c("Leto", "Dejavnost","Spol", "Stevilo"))
tabela9 <- arrange(tabela9,Leto, Dejavnost)
tabela9 <- subset(tabela9, Dejavnost!="Dejavnost eksteritorialnih organizacij in teles")

#_______________________ TABELA 10 __________________________________________________
#Spreminjanje GDP držav
url <- "podatki/gdppercapita.html"
stran <- read_html(url)
tabela10 <- stran %>% html_nodes(xpath="//table[@class='sortable wikitable']") %>% .[[1]] %>% html_table()
#tabela10 <- subset(tabela10, select = c("Year", "Dejavnost","Spol", "Stevilo"))
tabela10 <- pivot_longer(tabela10,cols=3:13,names_to = "Leto")
tabela10 <- tabela10 %>% rename(
    "Rang" = "Rank",
  "Drzava" = "Country",
  "GDP_per_capita_dolarji" = "value")
tabela10 <- subset(tabela10, select = c("Leto", "Drzava", "GDP_per_capita_dolarji"))
tabela10 <- arrange(tabela10,Leto, Drzava)
tabela10$GDP_per_capita_dolarji <- gsub("e","",tabela10$GDP_per_capita_dolarji)
tabela10$GDP_per_capita_dolarji <- gsub(",","",tabela10$GDP_per_capita_dolarji)
#tabela10 <- tabela10 %>% mutate(Drzava=slovar[Drzava])
tabela10$Leto <- as.numeric(as.character(tabela10$Leto))
tabela10$GDP_per_capita_dolarji <- as.numeric(tabela10$GDP_per_capita_dolarji)


#__________________TABELA 11__________________________________________________
#priseljevanje po državi in spolu, letno
imenastolpcev11 <- c("Leto", "Drzava", "Spol", "Starost", "Unit", "Neki", "Stevilo", "Neki2")
tabela11 <- read_csv("podatki/priseljevanjeevropa.csv", col_names = imenastolpcev11,skip=2,na=c(":"),
                     locale=locale(encoding = "Windows-1250"))
tabela11 <- subset(tabela11, select = c("Leto", "Drzava", "Spol","Stevilo"))
tabela11 <- tabela11 %>% filter(between(Leto,2011,2019))
#tabela11 <- tabela11 %>% mutate(Drzava=slovar[Drzava]) %>%
  #mutate(Spol=slovarspol[Spol])
tabela11$Drzava[tabela11$Drzava == "Germany (until 1990 former territory of the FRG)"] <- "Germany"


#_____________________ TABELA 12__________________________________________________
#odseljevanje po državi in spolu, letno
imenastolpcev12 <- c("Leto", "Drzava", "Spol", "Starost", "Unit", "Neki", "Stevilo", "Neki2")
tabela12 <- read_csv("podatki/odseljevanjeevropa.csv", col_names = imenastolpcev12,na=c(":"),skip=1,
                     locale=locale(encoding = "Windows-1250"))
tabela12 <- subset(tabela12, select = c("Leto", "Drzava", "Spol","Stevilo"))
tabela12 <- tabela12 %>% filter(between(Leto,2011,2019))
tabela12 <- tabela12  #mutate(Drzava=slovar[Drzava]) %>%
  #mutate(Spol=slovarspol[Spol])

tabela12$Leto <- as.numeric(as.character(tabela12$Leto))
tabela12$Stevilo <- as.numeric(as.character(tabela12$Stevilo))
tabela12$Drzava[tabela12$Drzava == "Germany (until 1990 former territory of the FRG)"] <- "Germany"



#__________________ TABELA 13 _______________________________________________________
#odseljeni v regije po letih
imenastolpcev13 <- c("Leto", "Regija","Spol","Stevilo_odseljenih_v_tujino")
tabela13 <- read_csv2("podatki/odseljeniregije.csv", col_names = imenastolpcev13,skip=3,
                     locale=locale(encoding = "Windows-1250"))

tabela13$Spol[tabela13$Spol == "Odseljeni v tujino - Ženske"] <- "Ženske"
tabela13$Spol[tabela13$Spol == "Odseljeni v tujino - Moški"] <- "Moški"

# _______________________tabela 14____________________________________________________
#priseljeni v regije po letih
imenastolpcev14 <- c("Leto", "Regija","Spol","Stevilo_priseljenih_iz_tujine")
tabela14 <- read_csv2("podatki/priseljeniregije.csv", col_names = imenastolpcev14,skip=3,
                      locale=locale(encoding = "Windows-1250"))
tabela14$Spol[tabela14$Spol == "Priseljeni iz tujine - Ženske"] <- "Ženske"
tabela14$Spol[tabela14$Spol == "Priseljeni iz tujine - Moški"] <- "Moški"


#________________________tabela 15____________________________________________________
#prebivalstvo evrope
imenastolpcev15 <- c("Leto", "Drzava", "Neki1", "Neki2", "Meritev", "Prebivalstvo")
tabela15 <- read_csv("podatki/demoeu.csv", col_names = imenastolpcev15,na=c(":"),skip=1,
                     locale=locale(encoding = "Windows-1250"))
tabela15$Drzava[tabela15$Drzava == "Germany including former GDR"] <- "Germany"
tabela15$Neki1 <- NULL
tabela15$Neki2 <- NULL
tabela15$Meritev <- NULL
drop_na(tabela15, Prebivalstvo)
tabela15$Prebivalstvo <- gsub(" ","",tabela15$Prebivalstvo)
tabela15$Prebivalstvo <- as.numeric(as.character(tabela15$Prebivalstvo))


#__________________ tabela 16 ____________________________________________
#prebivalstvo po regijah, letno
imenastolpcev16 <- c("Leto","Regija", "Neki1", "Neki2", "Prebivalstvo")
tabela16 <- read_csv2("podatki/regije_prebivalci.csv", col_names = imenastolpcev16,na=c(":"),skip=3,
                     locale=locale(encoding = "Windows-1250"))
tabela16$Neki1 <- NULL
tabela16$Neki2 <- NULL
tabela16$Leto <- gsub("H1","",tabela16$Leto)
tabela16$Leto <- as.numeric(as.character(tabela16$Leto))

#_______________ tabela 17_______________________________________________
#bdp na prebivalca, regije Slovenije
imenastolpcev17 <- c("Leto", "Regija", "BDP_na_prebivalca")
tabela17 <- read_csv2("podatki/bdp_regije.csv", col_names = imenastolpcev17,na=c(":"),skip=3,
                      locale=locale(encoding = "Windows-1250"))

#______________tabela 18___________________________________________________
#izobrazba, regije Slovenije
imenastolpcev18 <- c("Leto", "Spol","Starost","Regija", "Izobrazba", "Stevilo_izobrazba")
tabela18 <- read_csv2("podatki/izobrazba_regije.csv", col_names = imenastolpcev18,na=c(":"),skip=3,
                      locale=locale(encoding = "Windows-1250"))
tabela18$Starost <- NULL
tabela18$Spol <- NULL

vsi <- tabela18 %>% group_by(Regija, Leto) %>% summarise(vsi=sum(Stevilo_izobrazba))
visjes <- subset(tabela18, Izobrazba=="Višješolska, visokošolska - Skupaj") %>% rename("St_VS"="Stevilo_izobrazba")
ss <- subset(tabela18, Izobrazba=="Srednješolska - Skupaj") %>% rename("St_ss"="Stevilo_izobrazba")
visjes$Izobrazba <- NULL
ss$Izobrazba <- NULL
vsivis <- inner_join(vsi,visjes)
vse <- inner_join(vsivis,ss) %>% mutate(razSS=St_ss/vsi) %>% mutate(razVS=St_VS/vsi) 
vsezares <- subset(vse, select = c("Regija", "Leto","razSS","razVS"))

#________________________
#Za Shiny:
shiny_tab1 <- tabela6 %>% group_by(Leto,Izobrazba) %>% summarise(Stevilo=sum(Stevilo))
shiny_tab2 <- tabela1 %>% group_by(Leto,Drzava) %>% summarise(Stevilo=sum(Priseljeni_iz_tujine))
shiny_tab3 <- tabela8 %>% group_by(Leto,Dejavnost) %>% summarise(Stevilo=sum(Stevilo)) %>% drop_na(Stevilo)
shiny_tab4 <- tabela5 %>% group_by(Leto,Izobrazba) %>% summarise(Stevilo=sum(Stevilo_odseljenih))
shiny_tab5 <- tabela9 %>% group_by(Leto,Dejavnost) %>% summarise(Stevilo=sum(Stevilo)) %>% drop_na(Stevilo)
#________________________________________________________________________

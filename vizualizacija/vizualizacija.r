# 3. faza: Vizualizacija podatkov
library(jcolors)
library(dplyr)
library(ggrepel)
#uvozimo zemljevid Evrope

zemljevid <- uvozi.zemljevid(
  "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip", "ne_50m_admin_0_countries", encoding="UTF-8")
zemljevid <- zemljevid[zemljevid$CONTINENT == "Europe",]


cols1 <- c("#9fffe7",
           "#78e343",
           "#64bc8b",
           "#b7c172",
           "#c390b6",
           "#c9416d",
           "#cb4bab",
           "#de0004",
           "#02b0dd",
           "#67d564",
           "#025ecc",
           "#e7ff68",
           "#070043",
           "#ffdf41",
           "#f379ff",
           "#81a500",
           "#8e92ff",
           "#6d388a",
           "#32282f",
           "#c74d35",
           "#4c3560",
           "#086000",
           "#b9a192",
           "#ffaa44",
           "#004c4f",
           "#5d6994",
           "#53653b",
           "#ecffe2",
           "#4b0029",
           "#d0e0ff",
           "#7d4336",
           "#ff9096",
           "#b68247")


#-----------------------------------------------------------------------------------------------------------------------------------------------------
#Grafi o skupnem priseljevanju v Slovenijo

skupnopriseljevanje <- tabela1 
skupno_leta <- skupnopriseljevanje %>% group_by(Leto) %>% summarise(Vsota=sum(Priseljeni_iz_tujine))
skupno_leta_mz <- skupnopriseljevanje %>% group_by(Leto,Spol) %>% summarise(Stevilo_priseljenih=sum(Priseljeni_iz_tujine))

graf1 <- ggplot(data=skupno_leta, aes(x=Leto, y=Vsota)) + 
  geom_point(color=rgb(0.8,0.4,0.1,0.7))+
  geom_line(color=rgb(0.8,0.4,0.1,0.7)) +
  ylab('Skupno število priseljencev') + 
  xlab('Leto') + 
  ggtitle('Število priseljenih tujcev v Slovenijo skozi leta') +
  scale_x_continuous(breaks = 1*2011:2020) + 
  theme(axis.text.x=element_text(angle=0))

# graf 2: število priseljenih po spolu__________________________-

graf2 <- skupno_leta_mz %>%  ggplot(aes(x=Leto, y=Stevilo_priseljenih, col=Spol, palette="Pastel1")) + 
  geom_line() +
  ylab('Število priseljenih') + 
  xlab('Leto') + 
  labs(col = "Spol")+
  ggtitle('Število priseljenih ljudi v Slovenijo') +
  scale_x_continuous(breaks = 1*2011:2020) +
  theme(axis.text.x=element_text(vjust=0.5, hjust=0.5))

# graf 3: število priseljenih po državi:

graf3 <- skupnopriseljevanje %>%  ggplot(aes(x=Leto, y=Priseljeni_iz_tujine,col=Drzava, palette = "default")) + 
  geom_point() +
  ylab('Število priseljenih') + 
  xlab('Leto') + 
  ggtitle('Število priseljenih ljudi v Slovenijo') +
  scale_x_continuous(breaks = 1*2011:2020) +
  theme(axis.text.x=element_text(vjust=0.5, hjust=0.5))
graf3 <- graf3 + scale_color_manual(values=cols1)



#še en graf števila priseljenih po državi, skupno leta
pris_kolac <- ggplot(tabela1, aes(x = factor(1), y = Priseljeni_iz_tujine, fill = Drzava)) +
  xlab("") + ylab("") +
  geom_bar(width = 1, stat = "identity") + ggtitle("Države, iz katerih \n prihajajo priseljenci") + theme(legend.title=element_blank(), text = element_text(size=10))


pris_kolac <- pris_kolac + coord_polar("y", start=0)
pris_kolac <- pris_kolac + scale_fill_manual(values=cols1)


#_____________________________________________________________________
#naredila graf skupaj s podatki z izseljenimi in priseljenimi, število, letno

priseljeniinizseljeni <- inner_join(tabela1, tabela2, by=NULL) %>% mutate(Selitveni_prirast=Priseljeni_iz_tujine-Odseljeni_v_tujino) 
skupnopi_leta <- priseljeniinizseljeni %>% group_by(Leto) %>% summarise(Priseljeni_iz_tujine=sum(Priseljeni_iz_tujine), Odseljeni_v_tujino=sum(Odseljeni_v_tujino), Selitveni_prirast=sum(Selitveni_prirast))   
skupnopi_leta <- pivot_longer(skupnopi_leta,2:4, names_to="Vrsta", values_to="Stevilo") 
skupnopi_leta$Vrsta[skupnopi_leta$Vrsta == "Odseljeni_v_tujino"] <- "Izseljeni"
skupnopi_leta$Vrsta[skupnopi_leta$Vrsta == "Priseljeni_iz_tujine"] <- "Priseljeni"
skupnopi_leta$Vrsta[skupnopi_leta$Vrsta == "Selitveni_prirast"] <- "Selitveni prirast"

graf4 <- skupnopi_leta %>%  ggplot(aes(x=Leto, y=Stevilo, col=Vrsta, palette="Pastel1")) + 
  geom_line() +
  geom_point()+
  ylab('Število ljudi') + 
  xlab('Leto') + 
  labs(col = "Legenda:")+
  ggtitle('Število priseljenih in izseljenih ljudi v Sloveniji') +
  scale_x_continuous(breaks = 1*2011:2020) +
  theme(axis.text.x=element_text(vjust=0.5, hjust=0.5))

# graf 5: število izseljenih po spolu
skupno_leta_mz2 <- tabela2 %>% group_by(Leto,Spol) %>% summarise(Stevilo_izseljenih=sum(Odseljeni_v_tujino))
graf5 <- skupno_leta_mz2 %>%  ggplot(aes(x=Leto, y=Stevilo_izseljenih, col=Spol, palette="Pastel1")) + 
  geom_line() +
  ylab('Število ljudi') + 
  xlab('Leto') + 
  labs(col = "Spol")+
  ggtitle('Število odseljenih ljudi iz Slovenije') +
  scale_x_continuous(breaks = 1*2011:2020) +
  theme(axis.text.x=element_text(vjust=0.5, hjust=0.5))

#_______________________________________________________
#združiti priseljevanje in izseljevanje po spolu - facet grid
skupno_leta_mz_oboje <- inner_join(skupno_leta_mz,skupno_leta_mz2) %>% pivot_longer(3:4,names_to="Vrsta",values_to="Stevilo")
skupno_leta_mz_oboje$Vrsta[skupno_leta_mz_oboje$Vrsta == "Stevilo_priseljenih"] <- "Priseljeni"
skupno_leta_mz_oboje$Vrsta[skupno_leta_mz_oboje$Vrsta == "Stevilo_izseljenih"] <- "Izseljeni"
spol_graf <- ggplot(data=skupno_leta_mz_oboje, aes(x=Leto, y=Stevilo, col=Spol)) +
  geom_line() +
  ylab('Število ljudi') + 
  xlab('Leto') + 
  labs(col = "Spol")+
  facet_wrap(.~Vrsta) +
  ggtitle('Število priseljenih in izseljenih ljudi glede na spol') +
  scale_x_continuous(breaks = 1*2011:2020) +
  theme(axis.text.x=element_text(vjust=0.5, hjust=0.5, angle=90))



#____________________________________________________

#graf 6: število izseljenih po državi
tabelanova2 <- tabela2 %>% group_by(Leto, Drzava) %>% summarise(Odseljeni_v_tujino=sum(Odseljeni_v_tujino))
tabelanova2 <- tabelanova2 %>% rename("Država"="Drzava")
graf6 <- tabelanova2 %>%  ggplot(aes(x=Leto, y=Odseljeni_v_tujino, col=Država, palette = "default")) + 
  geom_point() +
  ylab('Število izseljenih') + 
  xlab('Leto') + 
  ggtitle('Izseljevanje iz Slovenije') +
  scale_x_continuous(breaks = 1*2011:2020) +
  theme(axis.text.x=element_text(vjust=0.5, hjust=0.5, angle=90))
graf6 <- graf6 + scale_color_manual(values=cols1)


#še en graf števila izseljenih po državi, skupno leta
drzava_izs_kolac <- ggplot(tabela2, aes(x = factor(1), y = Odseljeni_v_tujino, fill = Drzava)) +
  xlab("") + ylab("") +
  geom_bar(width = 1, stat = "identity") + ggtitle("Države, kamor odhajajo Slovenci (2011-19)") + theme(legend.title=element_blank())
drzava_izs_kolac <- drzava_izs_kolac + coord_polar("y", start=0)
drzava_izs_kolac <- drzava_izs_kolac + scale_fill_manual(values=cols1)

# STAROST
#Starost izseljencev
starosti <- c(seq(15, 65, 5) %>% paste0(., "-", .+4), "65 +")
starost_graf1 <- ggplot(data=tabela3, aes(x=Leto, y=Stevilo_odseljenih, fill=factor(Starost, starosti))) +
  geom_bar(stat="identity") + scale_x_continuous(breaks = 1*2011:2020) + ggtitle("Starost pri izselitvi iz Slovenije") +
  xlab("Leto") + ylab("Število") + labs(fill='Starost') + theme(axis.text.x=element_text(angle=0))
#Starost priseljencev
starosti2 <- c("0-14", seq(15, 65, 5) %>% paste0(., "-", .+4), "65 +")
starost_graf2 <- ggplot(data=tabela4, aes(x=Leto, y=Stevilo_priseljenih, fill=factor(Starost, starosti2))) +
  geom_bar(stat="identity") + scale_x_continuous(breaks = 1*2011:2020) + ggtitle("Starost pri priselitvi v Slovenijo") +
  xlab("Leto") + ylab("Število") + labs(fill='Starost') + theme(axis.text.x=element_text(angle=0))


# IZOBRAZBA
tabela5nova <- tabela5 %>% rename("Drzava"="Drzava_prihodnjega_bivalisca")
tabela6nova <- tabela6 %>% rename("Stevilo_priseljenih"="Stevilo") 
tabela_izobrazba <- inner_join(tabela5nova, tabela6nova, by=NULL) %>% 
  pivot_longer(5:6, names_to="Vrsta", values_to="Stevilo") 
tabela_izobrazba$Vrsta[tabela_izobrazba$Vrsta == "Stevilo_priseljenih"] <- "Priseljeni"
tabela_izobrazba$Vrsta[tabela_izobrazba$Vrsta == "Stevilo_odseljenih"] <- "Izseljeni"

Stopnja <- c("Osnovnošolska ali manj",	"Srednješolska","Višješolska, visokošolska")
izobrazba_graf <- ggplot(data=tabela_izobrazba, aes(x=Leto, y=Stevilo, fill=factor(Izobrazba, Stopnja))) +
  geom_bar(stat="identity") + facet_wrap(.~Vrsta) + scale_x_continuous(breaks = 1*2011:2020) + ggtitle("Izobrazba ljudi, ki so se preselili in izselili") +
  xlab("Leto") + ylab("Število") + labs(fill='Stopnja izobrazbe') + theme(axis.text.x=element_text(angle=90))


#NAMEN PRISELITVE

namen_priselitve <- ggplot(tabela7, aes(x = factor(1), y = Stevilo, fill = Namen)) + xlab("") + ylab("") +
  geom_bar(width = 1, stat = "identity") + ggtitle("Namen preselitve v Slovenijo za priseljence v letih od 2011 do 2019") + theme(legend.title=element_blank())


namen_priselitve <- namen_priselitve + coord_polar("y", start=0)

#DEJAVNOST

#Priseljeni prebivalci po dejavnosti
skupno_dejavnost <- tabela8 %>% group_by(Dejavnost) %>% summarise(Vsota=sum(Stevilo)) %>% mutate(Povprečje=round(Vsota/9,1))
skupno_dejavnost <- skupno_dejavnost %>% filter(Dejavnost %in% c("Gradbeništvo","Predelovalne dejavnosti","Promet in skladiščenje","Druge raznovrstne poslovne dejavnosti", "Trgovina, vzdrževanje in popravila motornih vozil", "Gostinstvo", "Strokovne, znanstvene in tehnične dejavnosti", "Informacijske in komunikacijske dejavnosti", "Izobraževanje", "Zdravstvo in socialno varstvo"))
dejavnost <- skupno_dejavnost %>% ggplot(aes(x=reorder(Dejavnost,-Povprečje), y=Povprečje,fill=Povprečje)) + 
  geom_bar(position="dodge", stat="identity") + 
  ylab('Povrečje') + 
  xlab("Dejavnost")+
  ggtitle('Povprečno število priseljencev glede na dejavnost v letih 2011-19') +
  theme(text = element_text(size=8), axis.text.x=element_text(vjust=0.5, hjust=0.5, angle=90))




#Izseljeni prebivalci po dejavnosti
skupno_dejavnost2 <- tabela9 %>% group_by(Dejavnost) %>% summarise(Vsota=sum(Stevilo)) %>% mutate(Povprečje=round(Vsota/9,1))
skupno_dejavnost2 <- skupno_dejavnost2 %>% filter(Dejavnost %in% c("Gradbeništvo","Predelovalne dejavnosti","Promet in skladiščenje","Druge raznovrstne poslovne dejavnosti", "Trgovina, vzdrževanje in popravila motornih vozil", "Gostinstvo", "Strokovne, znanstvene in tehnične dejavnosti", "Informacijske in komunikacijske dejavnosti", "Izobraževanje", "Zdravstvo in socialno varstvo", 
                                                                   "Dejavnosti javne uprave in obrambe, dejavnost obvezne socialne varnosti","Kmetijstvo in lov, gozdarstvo, ribištvo"))
dejavnost2 <- skupno_dejavnost2 %>% ggplot(aes(x=reorder(Dejavnost,-Povprečje), y=Povprečje,fill=Povprečje)) + 
  geom_bar(position="dodge", stat="identity") + 
  ylab('Povprečje') +
  xlab("Dejavnost")+
  ggtitle('Povprečno število izseljencev glede na dejavnost v letih 2011-19') +
  theme(text = element_text(size=8), axis.text.x=element_text(vjust=0.5, hjust=0.5, angle=90))


#priseljevanje po državah - povprečno število priseljenih letno v letih 2011-19
skupno_drzave <- tabela1 %>% group_by(Drzava) %>% summarise(Vsotadrzave=sum(Priseljeni_iz_tujine)) %>%
  mutate(Povprečje=round(Vsotadrzave/9,1))

drzave_priseljevanje <- skupno_drzave %>% ggplot(aes(x=reorder(Drzava,-Povprečje), y=Povprečje,fill=Povprečje)) + 
  geom_bar(position="dodge", stat="identity") + 
  ylab('Povrečje') + 
  xlab("Država")
  ggtitle('Povprečno število priseljencev letno glede na državo iz katere prihajajo za leta 2011-19') +
  theme(text = element_text(size=5), axis.text.x=element_text(vjust=0.5, hjust=0.5, angle=90))

#izseljevanje po državah - povprečno število izseljenih letno v letih 2011-19
skupno_drzave_izseljevanje <- tabela2 %>% group_by(Drzava) %>% summarise(Vsotadrzave2=sum(Odseljeni_v_tujino)) %>%
  mutate(Povprečje=round(Vsotadrzave2/9,1))

drzave_izseljevanje <- skupno_drzave_izseljevanje %>% ggplot(aes(x=reorder(Drzava,-Povprečje), y=Povprečje,fill=Povprečje)) + 
  geom_bar(position="dodge", stat="identity") + 
  ylab('Povrečje') + 
  xlab("Država") +
  ggtitle('Povprečno število izseljencev letno glede na državo v katero odhajajo za leta 2011-19') +
  theme(text = element_text(size=5), axis.text.x=element_text(vjust=0.5, hjust=0.5, angle=90))



#primerjava BDP in kamor se Slovenci največ izseljujejo
#zares je vizualizacija neuporabna...

izbrane <- c("Avstrija", "Nemčija", "Italija", "Švica", "Hrvaška")
BDPizbrane <- tabela10 %>%
  filter(Drzava %in% izbrane) %>% filter(between(Leto,2016,2019))
izseljevanjeizbrane <- tabela2 %>% group_by(Leto, Drzava) %>%
  summarise(Odseljeni_v_tujino=sum(Odseljeni_v_tujino)) %>%
  filter(Drzava %in% izbrane) %>% filter(between(Leto,2016,2019))
izbraneskupno <- inner_join(BDPizbrane, izseljevanjeizbrane) %>% pivot_longer(3:4, names_to="Vrsta", values_to="Stevilo") 

primerjava <- izbraneskupno %>% ggplot(aes(x=Leto, y=Stevilo, col=Vrsta)) +  geom_line() +
  ylab('Stevilo') + 
  xlab('Leto') + 
  facet_wrap(.~Drzava,ncol=3)+
  labs(col = "Vrsta")+
  ggtitle('Primerjava') +
 theme(axis.text.x=element_text(angle=90))

#za priseljevanje podobno
#isto neuporabno...
izbrane2 <- c("Bosna in Hercegovina", "Srbija", "Kosovo", "Severna Makedonija", "Hrvaška")
BDPizbrane2 <- tabela10 %>%
  filter(Drzava %in% izbrane2) %>% filter(between(Leto,2016,2019))
priseljevanjeizbrane <- tabela1 %>% group_by(Leto, Drzava) %>%
  summarise(Priseljeni_iz_tujine=sum(Priseljeni_iz_tujine)) %>%
  filter(Drzava %in% izbrane2) %>% filter(between(Leto,2016,2019))
izbraneskupno2 <- inner_join(BDPizbrane2, priseljevanjeizbrane) %>% pivot_longer(3:4, names_to="Vrsta", values_to="Stevilo") 

primerjava2 <- izbraneskupno2 %>% ggplot(aes(x=Leto, y=Stevilo, col=Vrsta)) +  geom_line() +
  ylab('Stevilo') + 
  xlab('Leto') + 
  facet_wrap(.~Drzava,ncol=3)+
  labs(col = "Vrsta")+
  ggtitle('Primerjava') +
  theme(axis.text.x=element_text(angle=90))


#ZEMLJEVIDI---------------------------------------------------------------------------

#povprečne priselitve v državi za leta 2011-19 na 100k - ZEMLJEVID

evropa_priseljevanje_leta <- tabela11 %>% group_by(Leto, Drzava) %>% summarise(Priseljeni=sum(Stevilo))
prebpriseljevanje <- inner_join(evropa_priseljevanje_leta,tabela15)
novo <- prebpriseljevanje %>% mutate(Sprem=(100000/Prebivalstvo)) %>% mutate(Stevilo_pris_na100k = round(Sprem * Priseljeni,0))  
povprecje2 <- novo %>% group_by(Drzava) %>% summarise(Povprečje=mean(Stevilo_pris_na100k)) %>% mutate(Povprečje=round(Povprečje,0))

zemljevid1 <- tm_shape(merge(zemljevid,
                            povprecje2,duplicateGeoms = TRUE,
                             by.x="SOVEREIGNT", by.y="Drzava"), xlim=c(-20,32), ylim=c(32,72)) +
  tm_polygons("Povprečje", title = "Povp št. priseljenih ljudi na 100k", breaks=c(0,500,800,1000,1500,2000,3000,4000,5000)) + 
  tm_layout(bg.color = "skyblue") + 
  tm_layout(main.title = "Povprečno št. priseljenih ljudi \n v državo 2011-19 na 100k", main.title.size = 1, legend.title.size = 1) 




#________________________________________________________________________
# histogram povprečnega priseljevanja na 100.000 prebivalcev

povprecjepravapris <- povprecje2 %>% mutate(Drzava=slovar[Drzava]) %>% subset(Drzava!="Bolgarija")
eu_priseljevanje <- povprecjepravapris %>% ggplot(aes(x=reorder(Drzava,-Povprečje), y=Povprečje,fill=Povprečje)) + 
  geom_bar(position="dodge", stat="identity") + 
  xlab("Država")+
  ylab('Povrečje') + 
  ggtitle('Povprečno število priseljencev na 100.000 prebivalcev 2011-19') +
  theme(text = element_text(size=5), axis.text.x=element_text(vjust=0.5, hjust=0.5, angle=90))



#povprečne izselitve v državi v letih 2011-19 na 100k - ZEMLJEVID
evropa_izseljevanje_leta <- tabela12 %>% group_by(Leto, Drzava) %>% summarise(Izseljeni=sum(Stevilo)) %>% filter(between(Leto,2011,2018))
prebizseljevanje <- inner_join(evropa_izseljevanje_leta,tabela15)
novo2 <- prebizseljevanje %>% mutate(Sprem=(100000/Prebivalstvo)) %>% mutate(Stevilo_izs_na100k = round(Sprem * Izseljeni,0))  
povprecje3 <- novo2 %>% group_by(Drzava) %>% summarise(Povprečje=mean(Stevilo_izs_na100k)) %>% mutate(Povprečje=round(Povprečje,0))

zemljevid2 <- tm_shape(merge(zemljevid,
                             povprecje3,duplicateGeoms = TRUE,
                             by.x="SOVEREIGNT", by.y="Drzava"), xlim=c(-25,32), ylim=c(32,72)) +
  tm_polygons("Povprečje", title = "Povpr. št. izseljenih na 100k", breaks=c(0,250,500,750,1000,1500,2000,2500)) + 
  tm_layout(bg.color = "skyblue") + 
  tm_layout(main.title = "Povprečno števolo izseljenih \n ljudi v državo 2011-19 na 100k", main.title.size = 1, legend.title.size = 1) 



#________________________________________________________________________
# histogram povprečnega izseljevanja na 100.000 prebivalcev

povprecjeprava <- povprecje3 %>% mutate(Drzava=slovar[Drzava]) %>% subset(Drzava!="Bolgarija")
eu_izseljevanje <- povprecjeprava %>% ggplot(aes(x=reorder(Drzava,-Povprečje), y=Povprečje,fill=Povprečje)) + 
  geom_bar(position="dodge", stat="identity") + 
  xlab("Država")+
  ylab('Povrečje') + 
  ggtitle('Povprečno število izseljencev na 100.000 prebivalcev 2011-19') +
  theme(text = element_text(size=5), axis.text.x=element_text(vjust=0.5, hjust=0.5, angle=90))


#___________________________________________________________________________________
#zemljevid izseljevanja iz slovenskih regij
slovenija_izseljevanje_leta <- tabela13 %>% group_by(Leto, Regija) %>% summarise(Izseljeni=sum(Stevilo_odseljenih_v_tujino)) 
regijeizseljevanje <- inner_join(slovenija_izseljevanje_leta,tabela16)
zdruzeno <- regijeizseljevanje %>% mutate(Sprem=(10000/Prebivalstvo)) %>% mutate(Stevilo_izs_na10000 = round(Sprem * Izseljeni,0))  
povprecje_sloi <- zdruzeno %>% group_by(Regija) %>% summarise(Povprečje=mean(Stevilo_izs_na10000)) %>% mutate(Povprečje=round(Povprečje,0))


Slovenija <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/SVN_adm_shp.zip",
                             "SVN_adm1", encoding = "UTF-8")  

Slovenija$NAME_1[Slovenija$NAME_1 == "GoriĹˇka"] <- "Goriška"
Slovenija$NAME_1[Slovenija$NAME_1 == "KoroĹˇka"] <- "Koroška"
Slovenija$NAME_1[Slovenija$NAME_1 == "Notranjsko-kraĹˇka"] <- "Notranjsko-kraška"
Slovenija$NAME_1[Slovenija$NAME_1 == "Obalno-kraĹˇka"] <- "Obalno-kraška"

Slovenija$NAME_1 <- Slovenija$NAME_1 %>%
  str_replace("Spodnjeposavska", "Posavska") %>%
  str_replace("Notranjsko-kraška", "Primorsko-notranjska")

zemljevid_slo1 <- tm_shape(merge(Slovenija, povprecje_sloi, by.x="NAME_1", by.y="Regija")) + 
  tm_polygons("Povprečje",palette="Purples")+ 
  tm_style("grey") +
  tm_layout(main.title="Povprečno število izseljenih ljudi na \n 10.000 prebivalcev", legend.position = c(0.75,0.1)) + tm_text(text='NAME_1', size=0.6)


#zemljevid povprečnega priseljevanja v slovenske regije na 10.000 prebivalcev
slovenija_priseljevanje_leta <- tabela14 %>% group_by(Leto, Regija) %>% summarise(Priseljeni=sum(Stevilo_priseljenih_iz_tujine)) 
regijepriseljevanje <- inner_join(slovenija_priseljevanje_leta,tabela16)
zdruzeno2 <- regijepriseljevanje %>% mutate(Sprem=(10000/Prebivalstvo)) %>% mutate(Stevilo_pris_na10000 = round(Sprem * Priseljeni,0))  
povprecje_slop <- zdruzeno2 %>% group_by(Regija) %>% summarise(Povprečje=mean(Stevilo_pris_na10000)) %>% mutate(Povprečje=round(Povprečje,0))

zemljevid_slo2 <- tm_shape(merge(Slovenija, povprecje_slop, by.x="NAME_1", by.y="Regija")) + 
  tm_polygons("Povprečje",palette="Greens")+ 
  tm_style("grey") +
  tm_layout(main.title="Povprečno število priseljenih ljudi \n na 10.000 prebivalcev", legend.position = c(0.75,0.1)) + tm_text(text='NAME_1', size=0.6)

#________________________________________

#Opcijsko:
#5. Zemljevid iz kje se največ preseljujejo v Slovenijo - glede na tabeli 1/2 (2 zemljevida...)

#62. video glej geom text, kako dodati text na graf za nek graf

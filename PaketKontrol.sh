#!/bin/bash

KIRMIZI='\033[0;31m'
YESIL='\033[0;32m'
MAVI='\033[0;34m'
SARI='\033[0;33m'
NORMAL='\033[0m'

while true
do

        echo -n "Lutfen bir paket adi girin: "
        read paket
        echo -e "${SARI}Paket kontrol ediliyor... ${NORMAL}"
        sudo apt show $paket > /dev/null 2>&1

        if [ $? -eq 0 ]
        then
                echo -e "${YESIL}\nPaket Bulundu! ${NORMAL}"
                break
        else
                apt-cache search "$paket" > /dev/null 2>&1
                if [ $? -eq 0 ]
                then
                        echo -e "${YESIL}\nPaket mevcut ancak farkli isimle, iste benzer paketler: ${NORMAL}"
                        apt-cache search "$paket" | awk '{if ($1 ~ /'"$paket"'/) print $1}' | head -n 20

                else
                        echo -e "${KIRMIZI}Paket Bulunamadi! ${NORMAL}"
                fi
        fi
done

while true
do
        dpkg -l | grep -qw "$paket"
        if [ $? -eq 0 ]
        then
                echo -n -e "$paket sistemde mevcut.\nPaketi guncellemek mi yoksa kaldirmak mi istersiniz? (guncelle/kaldir): "
                read guncelleme

                if [ $guncelleme = "guncelle" ]
                then
                        echo -e "${SARI}$paket guncelleniyor... ${NORMAL}"
                        sudo apt update > /dev/null 2>&1
                        sudo apt --only-upgrade install "$paket" > /dev/null 2>&1
                        if [ $? -eq 0 ]
                        then
                                echo -e "${YESIL}$paket basarili bir sekilde guncellenmistir! Cikis yapiliyor... ${NORMAL}"
                                exit 0
                        else
                                echo -e "${KIRMIZI}$paket guncellemesi basarisiz! Cikis yapiliyor... ${NORMAL}"
                                exit 1
                        fi
                elif [ $guncelleme = "kaldir" ]
                then
                        echo -e "${SARI}$paket kaldiriliyor... ${NORMAL}"
                        sudo apt remove $paket > /dev/null 2>&1
                        echo -e "${YESIL}$paket basarili bir sekilde kaldirilmistir. Cikis yapiliyor... ${NORMAL}"
                        exit 0
                else
                        echo -e "${KIRMIZI}Yanlis girdiniz, lutfen tekrar deneyiniz... ${NORMAL}"
                fi
        else
                echo -n "$paket sistemde mevcut degil ama indirilebilir. Indirmek ister misiniz? (evet/hayir): "
                read indir
                if [ $indir = "evet" ]
                then
                        echo -e "${SARI}$paket indiriliyor... ${NORMAL}"
                        sudo apt install $paket > /dev/null 2>&1
                        if [ $? -eq 0 ]
                        then
                                echo -e "${YESIL}$paket basarili bir sekilde indirilmistir! Cikis yapiliyor... ${NORMAL}"
                                exit 0
                        else
                                echo -e "${KIRMIZI}$paket indirilemedi! Cikis yapiliyor... ${NORMAL}"
                                exit 1
                        fi
                elif [ $indir = "hayir" ]
                then
                        echo "Paket indirilmedi. Cikis yapiliyor..."
                        exit 0
                else
                        echo -e "${KIRMIZI}Yanlis girdiniz, lutfen tekrar deneyiniz... ${NORMAL}"
                fi
        fi
done
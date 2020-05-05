#!/bin/bash

VIEW="[$0]:"
OSRE="/usr/lib/os-release"
LSBRE="/etc/lsb-release"
OSRE_BAK="$HOME/os-release.bak"
LSBRE_BAK="$HOME/lsb-release.bak"
OLDNAME=$(lsb_release -d | awk -F "\t" '{print $2}' | awk 'BEGIN{ORS = ""}{print $0}')


# ERROR_WINDOW関数
ERROR_WINDOW () {
    zenity --error --width 350 --title $0 --text $1
    exit 0
}

# INFO_WINDOW関数
INFO_WINDOW () {
    zenity --info --width 350 --title $0 --text $1
    exit 0
}

# ファイル有無の確認
if [ -e $OSRE ]; then
    printf "${VIEW} \033[32m${OSRE} found.\033[m\n"
    if [ -e $LSBRE ]; then
    printf "${VIEW} \033[32m${LSBRE} found.\033[m\n"
    else
        printf "${VIEW} \033[31m${LSBRE} not found.\033[m\n"
        ERROR_WINDOW "${LSBRE} not found."
    fi
else
    printf "${VIEW} \033[31m${OSRE} not found.\033[m\n"
    ERROR_WINDOW "${OSRE} not found."
fi

# メインメニュー
while :
do
    SELECT=$(zenity --list --radiolist --column=Selected --column "Functions" True "Change name" False "Restore"  --text "Select the functions..." --title $0)
    CODE1=$?
    # echo $CODE1
    case $CODE1 in
    0)
        # echo $SELECT
        if [ "${SELECT}" = "Change name" ]; then
            # Change name
            sudo cp $OSRE $OSRE_BAK || ERROR_WINDOW "Error. Failed to copy the file\"${OSRE}\"."
            printf "${VIEW} \033[32m${OSRE} has been backed up.\033[m\n"
            sudo cp $LSBRE $LSBRE_BAK || ERROR_WINDOW "Error. Failed to copy the file\"${LSBRE}\"."
            printf "${VIEW} \033[32m${LSBRE} has been backed up.\033[m\n"
            printf "${VIEW} \033[32mThe back up was complate.\033[m\n"
            # 新しい名前
            while :
            do
                NEWNAME=$(zenity --entry --title $0 --text "Please new DistroName...")
                CODE2=$?
                # echo $CODE2
                case $CODE2 in
                0)
                    zenity --question --width 350 --title $0 --text "Change \"${OLDNAME}\" to \"${NEWNAME}\" ."
                    CODE3=$?
                    # echo $CODE3
                    case $CODE3 in
                    0)
                        # 本処理
                        sudo sed -i "5 s/${OLDNAME}/${NEWNAME}/" $OSRE || ERROR_WINDOW "Error. Failed to edit the file\"${OSRE}\"."
                        printf "${VIEW} \033[32mThe changes was complete to \"${OSRE}\"\033[m\n"
                        sudo sed -i "4 s/${OLDNAME}/${NEWNAME}/" $LSBRE || ERROR_WINDOW "Error. Failed to edit the file\"${LSBRE}\"."
                        printf "${VIEW} \033[32mThe changes was complete to \"${LSBRE}\"\033[m\n"
                        INFO_WINDOW "Changes completed successfully."
                    ;;
                    1)
                        break
                    ;;
                    esac
                ;;
                1)
                    break
                ;;
                esac
            done
        elif [ "${SELECT}"="Restore" ]; then
            # Restore
            if [ -e $OSRE_BAK ]; then
                printf "${VIEW} \033[32m${OSRE_BAK} found.\033[m\n"
                if [ -e $LSBRE_BAK ]; then
                printf "${VIEW} \033[32m${LSBRE_BAK} found.\033[m\n"
                else
                    printf "${VIEW} \033[31m${LSBRE_BAK} not found.\033[m\n"
                    ERROR_WINDOW "${LSBRE_BAK} not found."
                fi
            else
                printf "${VIEW} \033[31m${OSRE_BAK} not found.\033[m\n"
                ERROR_WINDOW "${OSRE_BAK} not found."
            fi
            zenity --question --width 350 --title $0 --text "Do you want to restore the files?"
            CODE4=$?
            # echo $CODE4
            case $CODE4 in
            0)
                # 本処理
                sudo cp $OSRE_BAK $OSRE || ERROR_WINDOW "Error. Failed to copy the file\"${OSRE_BAK}\"."
                printf "${VIEW} \033[32mRestoration of ${OSRE} is complete.\033[m\n"
                sudo cp $LSBRE_BAK $LSBRE || ERROR_WINDOW "Error. Failed to copy the file\"${LSBRE_BAK}\"."
                printf "${VIEW} \033[32mRestoration of ${LSBRE} is complete.\033[m\n"
                printf "${VIEW} \033[32mRestore completed successfully.\033[m\n"
                INFO_WINDOW "Restore completed successfully."
            ;;
            1)
                break
            ;;
            esac
        else
            printf "${VIEW} \033[31mError. The processing could not be executed normally.\033[m\n"
        fi
        break
    ;;
    1)
        break
    ;;
    esac
done

exit 0
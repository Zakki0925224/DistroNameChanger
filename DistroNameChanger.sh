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

# ファイル有無の確認
if [ -e $OSRE ]; then
    echo "${VIEW} ${OSRE} found."
    if [ -e $LSBRE ]; then
    echo "${VIEW} ${LSBRE} found."
    else
        echo "${VIEW} ${LSBRE} not found."
        ERROR_WINDOW "${LSBRE} not found."
    fi
else
    echo "${VIEW} ${OSRE} not found."
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
            echo "${VIEW} ${OSRE} has been backed up."
            sudo cp $LSBRE $LSBRE_BAK || ERROR_WINDOW "Error. Failed to copy the file\"${LSBRE}\"."
            echo "${VIEW} ${LSBRE} has been backed up."
            echo "${VIEW} The back up was complate."
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
                        echo "${VIEW} The changes was complete to \"${OSRE}\""
                        sudo sed -i "4 s/${OLDNAME}/${NEWNAME}/" $LSBRE || ERROR_WINDOW "Error. Failed to edit the file\"${LSBRE}\"."
                        echo "${VIEW} The changes was complete to \"${LSBRE}\""
                        zenity --info --width 350 --title $0 --text "Changes completed successfully."
                        exit 0
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
                echo "${VIEW} ${OSRE_BAK} found."
                if [ -e $LSBRE_BAK ]; then
                echo "${VIEW} ${LSBRE_BAK} found."
                else
                    echo "${VIEW} ${LSBRE_BAK} not found."
                    ERROR_WINDOW "${LSBRE_BAK} not found."
                fi
            else
                echo "${VIEW} ${OSRE_BAK} not found."
                ERROR_WINDOW "${OSRE_BAK} not found."
            fi
            zenity --question --width 350 --title $0 --text "Do you want to restore the files?"
            CODE4=$?
            # echo $CODE4
            case $CODE4 in
            0)
                # 本処理
                sudo cp $OSRE_BAK $OSRE || ERROR_WINDOW "Error. Failed to copy the file\"${OSRE_BAK}\"."
                echo "${VIEW} Restoration of ${OSRE} is complete."
                sudo cp $LSBRE_BAK $LSBRE || ERROR_WINDOW "Error. Failed to copy the file\"${LSBRE_BAK}\"."
                echo "${VIEW} Restoration of ${LSBRE} is complete."
                echo "${VIEW} Restore completed successfully."
                zenity --info --width 350 --title $0 --text "Restore completed successfully."
                exit 0
            ;;
            1)
                break
            ;;
            esac
        else
            echo "${VIEW} Error."
        fi
        break
    ;;
    1)
        break
    ;;
    esac
done

exit 0
#!/usr/bin/env bash

VIEW="[$0]:"
OSRE="/usr/lib/os-release"
LSBRE="/etc/lsb-release"
OSRE_BAK="$HOME/os-release.bak"
LSBRE_BAK="$HOME/lsb-release.bak"
OLDNAME=$(lsb_release -d | awk -F "\t" '{print $2}' | awk 'BEGIN{ORS = ""}{print $0}')


# ERROR_WINDOW関数
ERROR_WINDOW () {
    zenity \
    --error \
    --width 350 \
    --title $0 \
    --text "${1}"
    exit 0

}

# INFO_WINDOW関数
INFO_WINDOW () {
    zenity \
    --info \
    --width 350 \
    --title $0 \
    --text "${1}"
    exit 0

}

# エラー出力
ERRPRINT () {
    printf "${VIEW} \033[31m${1}\033[m\n"
    ERROR_WINDOW "${1}"
}

# OK出力
OKPRINT () {
    printf "${VIEW} \033[32m${1}\033[m\n"
}

# 処理を呼び出す
CALL () {
    bash $0
}


# ファイル有無の確認
if [ -e $OSRE ]; then
    OKPRINT "${OSRE} found."

    if [ -e $LSBRE ]; then
    OKPRINT "${LSBRE} found."

    else
        ERRPRINT "${LSBRE} not found."

    fi

else
    ERRPRINT "${OSRE} not found."

fi

# メインメニュー
SELECT=$(
    zenity \
    --title $0 \
    --info \
    --text "Select the functions..." \
    --ok-label="Close" \
    --extra-button="Change name" \
    --extra-button="Restore"

)

MAINMENU=$?

case $MAINMENU in
    0)
        exit 0
        
    ;;
    *)
        :

    ;;
esac

case $SELECT in
    "Change name")
        # Change name
        sudo cp $OSRE $OSRE_BAK || ERRPRINT "Error. Failed to copy the file\"${OSRE}\"."
        OKPRINT "${OSRE} has been backed up."

        sudo cp $LSBRE $LSBRE_BAK || ERRPRINT "Error. Failed to copy the file\"${LSBRE}\"."
        OKPRINT "${LSBRE} has been backed up."

        OKPRINT "The back up was complate."

        NEWNAME=$(
            zenity \
            --entry \
            --title $0 \
            --text "Please new DistroName..."
            
            )
        CODE2=$?

        case $CODE2 in
            0)
                zenity \
                --question \
                --width 350 \
                --title $0 \
                --text "Change \"${OLDNAME}\" to \"${NEWNAME}\" ."

                CODE3=$?

                case $CODE3 in
                    0)
                        # 本処理
                        sudo sed -i "5 s/${OLDNAME}/${NEWNAME}/" $OSRE || ERRPRINT "Error. Failed to edit the file\"${OSRE}\"."
                        OKPRINT "The changes was complete to \"${OSRE}\""

                        sudo sed -i "4 s/${OLDNAME}/${NEWNAME}/" $LSBRE || ERRPRINT "Error. Failed to edit the file\"${LSBRE}\"."
                        OKPRINT "The changes was complete to \"${LSBRE}\""

                        INFO_WINDOW "Changes completed successfully."

                        exit 0

                    ;;
                    1)
                        :
                    
                    ;;
                esac
            ;;
            1)
                :
            
            ;;
        esac

    ;;
    "Restore")
        # Restore
        if [ -e $OSRE_BAK ]; then
            OKPRINT "${OSRE_BAK} found."

            if [ -e $LSBRE_BAK ]; then
            OKPRINT "${LSBRE_BAK} found."

            else
                ERRPRINT "${LSBRE_BAK} not found."

            fi
        else
            ERRPRINT "${OSRE_BAK} not found."

        fi

        zenity \
        --question \
        --width 350 \
        --title $0 \
        --text "Do you want to restore the files?"

        CODE4=$?

        case $CODE4 in
            0)
                # 本処理
                sudo cp $OSRE_BAK $OSRE || ERRPRINT "Error. Failed to copy the file\"${OSRE_BAK}\"."
                OKPRINT "Restoration of ${OSRE} is complete."

                sudo cp $LSBRE_BAK $LSBRE || ERRPRINT "Error. Failed to copy the file\"${LSBRE_BAK}\"."
                OKPRINT "Restoration of ${LSBRE} is complete."

                OKPRINT "Restore completed successfully."
                INFO_WINDOW "Restore completed successfully."
            ;;
            1)
                :
            ;;
        esac

    ;;
    *)
        ERRPRINT "Error. Exception occured."

        exit 0

    ;;
esac


CALL
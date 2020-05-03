#!/bin/bash

VIEW="[$0]"
OSRE="/usr/lib/os-release"
LSBRE="/etc/lsb-release"
OSRE_BAK="$HOME/os-release.bak"
LSBRE_BAK="$HOME/lsb-release.bak"
OLDNAME=$(lsb_release -d | awk -F "\t" '{print $2}' | awk 'BEGIN{ORS = ""}{print $0}')

# ファイル有無の確認
if [    -e $OSRE   ]; then
    echo "${VIEW} ${OSRE} found."
    if [    -e $OSRE   ]; then
    echo "${VIEW} ${LSBRE} found."
    else
        echo "${VIEW} ${OSRE} not found."
        zenity --error --title $0 --text "Error."
        exit 0
    fi
else
    echo "${VIEW} ${OSRE} not found."
    zenity --error --title $0 --text "Error."
    exit 0
fi

# メインメニュー
zenity --question --title $0 --text "Please select action..." --ok-label "Change name" --cancel-label "Restore"
case $? in
0)
    # 「Change name」
    sudo cp $OSRE $OSRE_BAK
    echo "${VIEW} ${OSRE} has been backed up."
    sudo cp $LSBRE $LSBRE_BAK
    echo "${VIEW} ${LSBRE} has been backed up."
    echo "${VIEW} The back up was complate."
    NEWNAME=$(zenity --entry --title $0 --text "Please new DistroName...")
    zenity --question --title $0 --text "Change \"${OLDNAME}\" to \"${NEWNAME}\" ." --ok-label "Yes" --cancel-label "Cancel"
    case $? in
    0)
    # 本処理
    sudo sed -i "s/${OLDNAME}/${NEWNAME}/" $OSRE
    if [    $OLDNAME = $NEWNAME  ]; then
        echo "${VIEW} The changes was complete to \"${OSRE}\""
    else
        echo "${VIEW} The processing could not be completed."
    fi
    sudo sed -i "s/${OLDNAME}/${NEWNAME}/" $LSBRE
    echo "${VIEW} The changes was complete to \"${LSBRE}\""
    zenity --info --title $0 --text "Changes completed successfully."
    ;;
    1)
    exit 0
    ;;
    esac
;;
1)
    # 「Restore」
    if [    -e $OSRE_BAK   ]; then
    echo "${VIEW} ${OSRE_BAK} found."
        if [    -e $OSRE_BAK   ]; then
        echo "${VIEW} ${LSBRE_BAK} found."
        zenity --question --title $0 --text "Do you really want to restore it?" --ok-label "Yes" --cancel-label "Cancel"
        case $? in
        0)
        # 本処理
        sudo cp $OSRE_BAK $OSRE
        sudo cp $LSBRE_BAK $LSBRE
        zenity --info --title $0 --text "Restore completed successfully."
        exit 0
        ;;
        1)
        exit 0
        ;;
        esac
    
        else
            echo "${VIEW} ${OSRE_BAK} not found."
            zenity --error --title $0 --text "Error."
            exit 0
        fi
    else
        echo "${VIEW} ${OSRE_BAK} not found."
        zenity --error --title $0 --text "Error."
        exit 0
    fi
;;
esac
#! /bin/bash
cd "$(dirname "$0")"
export WINEPREFIX=$(pwd);

if [ "$#" -ne 1 ]; then
	echo "${0}: usage: installer.sh (1 for first run (initial setup) | 2 (to login) | 3 (to start program) )"
	exit 1
fi

case "${1}" in #switch case for the program's argument
    "1")
        tar -xzf installer.tar.gz;
        #winetricks vcrun2017 d3d11=disabled win7
        winetricks atmlib gdiplus msxml3 msxml6 vcrun2017 corefonts winhttp d3d11=disabled win7;
        echo -e "\n\n"
        echo "----------------------------------------------------------"
        echo "Wait for streamer.exe to be done downloading/installing..."
        echo "Watch "$WINEPREFIX"/drive_c/users/"$USER"/Local Settings/Application Data/Autodesk/webdeploy/"
        echo "And wait until a \"production\" folder appears with 2 populated subfolders"
        echo "----------------------------------------------------------"
        export WINEPREFIX=$(pwd);
        wine ./installer/streamer.exe
        ;;
        
    "2")
        echo "Remove the \"d3d11\" entry under libraries"
        export WINEPREFIX=$(pwd);
        winecfg;
        wine $WINEPREFIX"/drive_c/users/"$USER"/Local Settings/Application Data/Autodesk/webdeploy/production/6a0c9611291d45bb9226980209917c3d/FusionLauncher.exe";
        ;;
    "3")
        if [ ! -d dxvkInstaller ]; then
            curl -s https://api.github.com/repos/doitsujin/dxvk/releases/latest | grep ".tar.gz" | cut -d : -f 2,3 | tr -d \" | wget -qi -
            tar -xvf dxvk-*.tar.gz
            rm dxvk-*.tar.gz
            mv dxvk-* dxvkInstaller
            dxvkInstaller/setup_dxvk.sh install
            echo "DXVK installed!";
        else 
            dxvkInstaller/setup_dxvk.sh uninstall
            rm -rf dxvkInstaller
            echo "DXVK uninstalled!";
        fi     
        ;;
    "4")
        export WINEPREFIX=$(pwd);
        wine $WINEPREFIX"/drive_c/users/"$USER"/Local Settings/Application Data/Autodesk/webdeploy/production/6a0c9611291d45bb9226980209917c3d/FusionLauncher.exe";
        ;;
esac
exit

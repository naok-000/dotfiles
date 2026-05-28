{
  config,
  pkgs,
  lib,
  ...
}: let
  skkDataDir = ".local/share/skk";
  skkUserDictionary = "skk-jisyo.utf8";
  macSkkUserDictionary = "${config.home.homeDirectory}/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries/${skkUserDictionary}";
  userDictionary =
    if pkgs.stdenv.isDarwin
    then macSkkUserDictionary
    else "${config.home.homeDirectory}/${skkDataDir}/${skkUserDictionary}";

  dictionaries = with pkgs.skkDictionaries; [
    {
      package = l;
      file = "SKK-JISYO.L";
    }
    {
      package = itaiji;
      file = "SKK-JISYO.itaiji";
    }
    {
      package = itaiji_jis3_4;
      file = "SKK-JISYO.itaiji.JIS3_4";
    }
    {
      package = jis2;
      file = "SKK-JISYO.JIS2";
    }
    {
      package = jis2004;
      file = "SKK-JISYO.JIS2004";
    }
    {
      package = jis3_4;
      file = "SKK-JISYO.JIS3_4";
    }
    {
      package = law;
      file = "SKK-JISYO.law";
    }
    {
      package = mazegaki;
      file = "SKK-JISYO.mazegaki";
    }
    {
      package = geo;
      file = "SKK-JISYO.geo";
    }
    {
      package = station;
      file = "SKK-JISYO.station";
    }
    {
      package = zipcode;
      file = "SKK-JISYO.zipcode";
    }
    {
      package = zipcode;
      file = "SKK-JISYO.office.zipcode";
    }
    {
      package = china_taiwan;
      file = "SKK-JISYO.china_taiwan";
    }
    {
      package = okinawa;
      file = "SKK-JISYO.okinawa";
    }
    {
      package = edict;
      file = "SKK-JISYO.edict";
    }
    {
      package = propernoun;
      file = "SKK-JISYO.propernoun";
    }
    {
      package = jinmei;
      file = "SKK-JISYO.jinmei";
    }
    {
      package = fullname;
      file = "SKK-JISYO.fullname";
    }
  ];

  dictionarySource = dictionary: "${dictionary.package}/share/skk/${dictionary.file}";
  globalDictionaries = map dictionarySource dictionaries;
in {
  home.sessionVariables = {
    SKK_GLOBAL_DICTIONARIES = lib.concatStringsSep ":" globalDictionaries;
    SKK_USER_DICTIONARY = userDictionary;
  };
}

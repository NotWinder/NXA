{
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Lexmark E120";
        location = "Home";
        deviceUri = "usb://Lexmark/1250%20Color%20Printer?serial=9955KGK";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
  };
}

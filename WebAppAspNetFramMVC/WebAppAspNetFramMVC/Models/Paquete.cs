using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebAppAspNetFramMVC.Models
{
    public class Paquete
    {
        public string Cod_paquete { get; set; }
        public string Descripcion { get; set; }
        public string Destinatario { get; set; }
        public string Direccion_destinatario { get; set; }
        public string Cedula_conductor { get; set; }
        public string Provincia_destino { get; set; }
    }
}
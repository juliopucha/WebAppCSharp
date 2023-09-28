using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebAppAspNetFramMVC.Models
{
    public class ConductorCamion
    {
        public string Cedula_conductor { get; set; }
        public string Nombre_conductor { get; set; }
        public string Placa { get; set; }
        public string Modelo { get; set; }
        public DateTime Fecha_coduccion { get; set; }

    }
}
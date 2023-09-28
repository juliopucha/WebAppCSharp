using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebAppAspNetFramMVC.Models
{
    public class GestionCourier :MantenimientoPaquete
    {
        MantenimientoPaquete mp = new MantenimientoPaquete();
        public void conexion() 
        {
            // Es importante tomar en cuenta, que el m-etodo al cual se piensa acceder, no puede ser
            // accesible debido a su nivel de protecci-on.

            // La llamada a un m-etodo heredado o que comparte el mismo "espacio de nombres"
            // se debe realizar desde el interior de otro m-etodo.            
            //mp.Conectar(); // No se requiere herencia cuando est-a dentro del mismo espacio de trabajo.
            
            //----------------------------------------------------
             //GestionCourier gc = new GestionCourier();
             //gc.Conectar(); // Haciendo uso de la herencia, solo para probar.
        }


       
        
        //public List<ConductorCamion> conductoresConducenCamionesPorPlaca(string placa) 
        //{
        //    return new ConductorCamion (){ Nombre_conductor = "" }
        //}
    }
}
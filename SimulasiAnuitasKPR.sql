DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ulangBulan2`(IN `dateForm` DATETIME, IN `platfon` INT, IN `bunga` REAL, IN `lamaPinjam` INT)
    DETERMINISTIC
BEGIN
             DECLARE i INT DEFAULT 1;
             DECLARE j INT DEFAULT 1;
             
             DECLARE besAngsuran real;
             DECLARE pAngsuran real;
             DECLARE bAngsuran real;
             DECLARE tAngsuran real;
             DECLARE tAngsuranTemp real;
             DECLARE sPinjaman real;
             DECLARE sPinjamanTemp real;

             DROP TABLE IF EXISTS anuitas;
             
             CREATE TEMPORARY TABLE anuitas
                 (
                     angsuranke int, 
                     tanggal date, 
                     totalAngsuran real,
                     angsuranPokok real,
                     angsuranBunga real, 
                     sisaPinjam real
                 );
                 
         SET sPinjaman = @p1;

         WHILE i <= @p3 DO

                #SET besAngsuran = 
                #@p2 * @p1 * (SELECT POWER((1 + @p2), @p3)) / 
                #          (SELECT POWER((1 + @p2), @p3) - 1);
                          
                SET besAngsuran = @p1 * ((@p2/12)/(1-(SELECT POWER(
                                  (1+(@p2/12)),-@p3))));

                SET bAngsuran = @p2 / 360 * 30 * sPinjaman;
                
                SET pAngsuran = besAngsuran - bAngsuran;
                #SET tAngsuranTemp = besAngsuran - bAngsuran;
                SET sPinjaman = sPinjaman - pAngsuran;

                SET tAngsuran = pAngsuran + bAngsuran;

                INSERT INTO anuitas 
                VALUES(
                       i,
                       @p0,
                       besAngsuran,
                       pAngsuran,
                       bAngsuran,
                       sPinjaman
                );
                SET i=i+1;

         END WHILE;

         select * from anuitas;
         drop table anuitas;
END$$
DELIMITER ;
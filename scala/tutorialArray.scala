import scala.collection.mutable._
object  ScalaTutorial {

  def main(args: Array[String]) {

    val favNums = new Array[Int](20)

    val friends = Array("Bob", "Tom")

    friends(0) = "Sue"

    println(" Best frients " +  friends(0))
    for ( f <- friends )
      println("Friend = " + f)

    val friends2 = new ArrayBuffer[String]()

    friends2.insert(0, "Phil")

    friends2 += "Mark"
    friends2 ++= Array ("James" , "Suzy")
    for ( f <- friends2 )
      println("Friend2 = " + f)


    for ( j <- 0 to ( favNums.length - 1 )) {
      favNums(j) = j
      println("FavNums = " + j)
    }

    println("Number * 2  " )
    val favNumsTime2 = for ( num <- favNums ) yield 2 * num
    favNumsTime2.foreach(println)

    println("Number divide by 4 " )
    val favNumsDiv4 = for( num <- favNums if num %4 == 0 ) yield num
    favNumsDiv4.foreach(println)

    println("MultTable " )
    var mutlTable = Array.ofDim[Int](10,10)

    for( i <- 0 to 9 ; j <- 0 to 9)
      mutlTable(i)(j) = i * j

    for( i <- 0 to 9 ; j <- 0 to 9)
      printf("%d : %d = %d\n", i , j, mutlTable(i)(j))
  }
}
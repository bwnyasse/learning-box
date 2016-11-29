/*
* My first Scala object
 */
object ScalaTutorial {

  def main(args: Array[String]) {

    /*=============================*/
    println("SIMPLE WHILE LOOP :")
    var i = 0;
    while (i <= 10) {
      println("args = " + i)
      i += 1
    }
    println()

    /*=============================*/
    println("DO WHILE LOOP :")
    var j = 0;
    do {
      println("args = " + j)
      j += 1
    } while (j <= 20)
    println()

    /*=============================*/
    println("SIMPLE FOR LOOP :")
    for (i <- 0 to 5 )
      println("i = " + i)

    println()
    val randLetters = "ABCDEFGHI"
    for ( i <- 0 until randLetters.length) // cool for String or Arrays
      println("Letter :" +  randLetters(i))

    println()
    val list = List(1,2,3,4,5)
    for ( i <- list ) {
      println("List Item = " + i)
    }

    println()
    val evenList = for { i <- 1 to 10
      if (i % 2 ) == 0
    } yield i

    for ( i <- evenList  ) {
      println("eventList value = " + i)
    }

    println("SIMPLE interleaves LOOP  :")
    for ( i <- 0 to 2 ; j <- 1 to 3 ) {
      println("i = " + i)
      println("j = " + j)
    }


  }

}


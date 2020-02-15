public class DockerTest {
  public static void main(String[] args) throws InterruptedException {
    Runtime runtime = Runtime.getRuntime();
    // availableProcessors() method returns the number of processors 
    // available to the Java virtual machine
    int  cpus = runtime.availableProcessors();
    // maxMemory() returns the maximum amount of memory the JVM attempts to use 
    // and is being set implicitly to a quarter of the total existing RAM
    long mmax = runtime.maxMemory() / 1024 / 1024;
    System.out.println("System properties");
    System.out.println("Cores       : " + cpus);
    System.out.println("Memory (Max): " + mmax);
    if(System.getProperty("loop")!=null && System.getProperty("loop").equals("true")){
      while (true) Thread.sleep(1000);
    }
  }
}
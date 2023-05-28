public void projection() {
  println("Project Happening");
  isFinished = false;
  int updateTime = 1000/projectionSpeed;
  time = 0;
  int savedTime = millis();
  while (!isFinished) {
    int timePassed = (millis() - savedTime);
    ArrayList<int> timeArray = pictureTimesArray.get(time);
    for (int p = 0; p < timeArray.size(); p++) {

      int pixel = timeArray.get(p);
      color pixelColor = projectionImg.pixels[pixel];
      int redColor = (int)red(pixelColor);
      int greenColor = (int)green(pixelColor);
      int blueColor = (int)blue(pixelColor);

      int pixelRedTime = 0;
      int pixelGreenTime = 0;
      int pixelBlueTime = 0;

      if (redColor < 128) {
        OptimizedTimes pixel = optValues1.get(redColor + "," + greenColor + "," + blueColor);
        pixelRedTime = pixel.getRed();
        pixelGreenTime = pixel.getGreen();
        pixelBlueTime = pixel.getBlue();
      }
      if (redColor >= 128) {
        OptimizedTimes pixel = optValues2.get(redColor + "," + greenColor + "," + blueColor);
        pixelRedTime = pixel.getRed();
        pixelGreenTime = pixel.getGreen();
        pixelBlueTime = pixel.getBlue();
      }

      int newRedColor = (time >= pixelRedTime ? 0:255);
      int newGreenColor = (time >= pixelGreenTime ? 0:255);
      int newBlueColor = (time >= pixelBlueTime ? 0:255);

      projectedImage.pixels[pixel] = color(newRedColor, newGreenColor, newBlueColor);

    }
    if (timePassed >= updateTime) {
      // Behind schedule - immediately handle next time
      println("Behind schedule at time=" + time);
      println("Handled " + timeArray.size() + " pixels");
      savedTime += updateTime;
    } else {
      long sleepTime = updateTime - timePassed;
      //println(sleepTime);
      try {
        Thread.sleep(sleepTime);
      }
      catch(InterruptedException e) {
        println("Got interrupted!");
      }
    }
    projectedImage.updatePixels();
    savedTime = millis();
    projectorScreen.setProject(true);
    projectorScreen.setImage(projectedImage);
    updateBackground();
    time++;

    if (time >= pictureDuration) {
      projectorScreen.setProject(false);
      isFinished = true;
      state = 1;
      showPreview = "no";
      updateBackground();
    }
  }
}

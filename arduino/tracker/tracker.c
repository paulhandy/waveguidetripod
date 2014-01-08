
void tracker(int flag){
  switch(flag){
    case 1:
      // serial is available, current center is set. just get the sine wave going.
      break;
    case 2:
      // serial is available, one period is passed.
      // find new center.
      break;
    case 3:
      // serial is unavailable, center was found, osciallate about center
      break;
    case 4:
      // serial is unavailable, spin all the way around, searching for a signal.
      break;
    case 5:
      // serial is unavailable, no signal found, so let's turn off and wait for a signal to come.
      break;
  }
}

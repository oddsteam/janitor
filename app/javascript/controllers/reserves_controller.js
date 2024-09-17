import { Controller } from "@hotwired/stimulus";
import {openModal} from "../modal";

export default class extends Controller {
  static targets = ["cell", "optionsStart", "optionsEnd"];
  dragging = false;
  selectedCells = [];
  startRow = null;

  startTime = null;
  endTime = null;

  option() {
    this.startTime 
    this.optionsStartTarget.innerHTML = '';
    this.optionsEndTarget.innerHTML = '';
    // create array of options to be added
    // เพิ่ม <option> elements เข้าไปใน optionTarget
    this.optionsStartTarget.appendChild(option1);
    this.optionsEndTarget.appendChild(option2);
  }

  handleStart(event) {
    event.preventDefault();
    this.dragging = true;
    this.removeHighlightCell(); // ลบ row ที่เลือกไว้ก่อนหน้า ก่อนลากใหม่
    this.startRow = this.getRowIndex(event.currentTarget); // ลาก row เปลี่ยนสี
    this.highLightCell(event.currentTarget); // ตัวเปลี่ยนสี

    this.startTime = event.currentTarget.dataset.startTime;
    // console.log('startTime: ' + this.startTime);
  }
  
  handleMove(event) {
    if (!this.dragging) return;
    event.preventDefault();
    const element = event.currentTarget;
    
    if (element && element.matches("[data-reserves-target='cell']")) {
      const currentRow = this.getRowIndex(element);
      
      // Check if the current row is the same as the start row
      if (currentRow === this.startRow) {
        this.highLightCell(element);
      } else {
        // If dragging across a different row, stop and end the drag
        console.log("Dragged across rows, stopping the selection.");
        this.handleEnd(event); // Call handleEnd to finish the selection process
      }
    }
  }

  handleEnd(event) {
    event.preventDefault();
    if (!this.dragging) return;
    this.dragging = false;

    this.endTime = event.currentTarget.dataset.endTime;
    // console.log('endTime: ' + this.endTime);
  }

  highLightCell(cell) {
    if (!this.selectedCells.includes(cell)) {
      this.selectedCells.push(cell);
      cell.classList.add("bg-blue-300");
    }
  }
  
  removeHighlightCell() {
    this.selectedCells.forEach(cell => cell.classList.remove("bg-blue-300"));
    this.selectedCells = [];
  }

  getRowIndex(cell) {
    return cell.closest('tr').rowIndex;
  }
}

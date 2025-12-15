把 重置後自動顯示「已更新」提示（例如 Bulma 的 notification）加上去，讓使用者更清楚知道已經套用新設定
好的，我來幫你加上 **重置後自動顯示「已更新」提示**。我們可以利用 Bulma 的 `notification` 元件，在呼叫 `resetTimer()` 時動態插入提示，幾秒後自動消失。

---

## 修改方式

### 1. 在 HTML 加一個提示容器
放在主畫面頂部或計時器上方：

```html
<!-- 提示容器 -->
<div id="updateNotice" style="display:none;" class="notification is-success is-light has-text-centered">
  <button class="delete" id="closeNoticeBtn"></button>
  <span><i class="fa-solid fa-circle-check"></i>&nbsp;已更新設定</span>
</div>
```

你可以放在 `<section class="section pt-4">` 裡的最上方，或 sticky header 下方。

---

### 2. 在 JavaScript 的 `resetTimer()` 裡加顯示邏輯

```js
function resetTimer() {
  pauseTimer();
  stopSound();
  setMode('work');
  state.tomatoes = state.currentTask ? (state.currentTask.tomatoes || 0) : 0;
  updateHeader();

  // 顯示「已更新」提示
  showUpdateNotice();
}

function showUpdateNotice() {
  const notice = document.getElementById('updateNotice');
  notice.style.display = 'block';
  // 3 秒後自動隱藏
  setTimeout(() => {
    notice.style.display = 'none';
  }, 3000);
}

// 關閉按鈕事件
document.getElementById('closeNoticeBtn').addEventListener('click', () => {
  document.getElementById('updateNotice').style.display = 'none';
});
```

---

## 效果

- 當使用者修改 **時間設定** 或 **任務內容** 後，程式呼叫 `resetTimer()`，會自動顯示一個 Bulma 綠色提示框「已更新設定」。  
- 提示框會在 **3 秒後自動消失**，或使用者點擊右上角的 `×` 關閉。  
- 這樣使用者就能清楚知道設定已經套用。

---

要不要我再幫你加上 **不同顏色提示**（例如時間設定用藍色、任務修改用綠色），讓使用者更容易分辨是哪個更新？
好的，我來幫你把 **不同顏色提示** 加上去，讓使用者更容易分辨是哪一種更新。  
我們可以在 `showUpdateNotice()` 函式裡傳入一個「類型」參數，根據不同情境套用 Bulma 的顏色類別。

---

## 1. HTML 提示容器
保持一個容器即可，顏色由 JS 動態切換：

```html
<div id="updateNotice" style="display:none;" class="notification has-text-centered">
  <button class="delete" id="closeNoticeBtn"></button>
  <span id="updateMessage"></span>
</div>
```

---

## 2. JavaScript 顯示邏輯

```js
function showUpdateNotice(type) {
  const notice = document.getElementById('updateNotice');
  const msg = document.getElementById('updateMessage');

  // 先移除舊的顏色類別
  notice.className = 'notification has-text-centered';

  // 根據不同類型套用顏色與文字
  if (type === 'time') {
    notice.classList.add('is-info', 'is-light');
    msg.innerHTML = '<i class="fa-solid fa-clock"></i>&nbsp;時間設定已更新';
  } else if (type === 'task') {
    notice.classList.add('is-success', 'is-light');
    msg.innerHTML = '<i class="fa-solid fa-list-check"></i>&nbsp;任務已更新';
  } else {
    notice.classList.add('is-primary', 'is-light');
    msg.innerHTML = '<i class="fa-solid fa-circle-check"></i>&nbsp;已更新設定';
  }

  notice.style.display = 'block';

  // 3 秒後自動隱藏
  setTimeout(() => {
    notice.style.display = 'none';
  }, 3000);
}

// 關閉按鈕事件
document.getElementById('closeNoticeBtn').addEventListener('click', () => {
  document.getElementById('updateNotice').style.display = 'none';
});
```

---

## 3. 在修改後呼叫不同顏色提示

- **時間設定儲存後：**

```js
saveTimeBtn.addEventListener('click', async () => {
  // 更新任務的工作/休息時間
  if (state.currentTask && !state.currentTask.completed) {
    state.currentTask.workMinutes = Math.max(1, Number(workInput.value));
    state.currentTask.breakMinutes = Math.max(1, Number(breakInput.value));
    await updateTask(state.currentTask);
  }
  closeModal(timeModal);
  resetTimer();
  showUpdateNotice('time');  // 顯示藍色提示
});
```

- **任務修改後：**

```js
detailForm.addEventListener('submit', async (e) => {
  e.preventDefault();
  if (!state.selectedTaskId) return;
  const tasks = await listTasks();
  const task = tasks.find(t => t.id === state.selectedTaskId);
  if (!task || task.completed) return;
  task.title = detTitle.value.trim() || '(未命名)';
  task.description = detDesc.value.trim();
  task.priority = detPri.value;
  task.category = detCat.value.trim();
  task.workMinutes = Math.max(1, Number(detWork.value || 25));
  task.breakMinutes = Math.max(1, Number(detBreak.value || 5));
  await updateTask(task);
  resetTimer();
  showUpdateNotice('task');  // 顯示綠色提示
});
```

---

## 效果

- **時間設定更新** → 顯示藍色 `is-info` 提示框，文字「時間設定已更新」。  
- **任務更新** → 顯示綠色 `is-success` 提示框，文字「任務已更新」。  
- 提示框會在 **3 秒後自動消失**，或使用者點擊 `×` 關閉。  

---

要不要我再幫你加上 **不同圖示**（例如時間用 `fa-clock`、任務用 `fa-list-check`），讓提示更直覺？

//实验二脚本
console.log('脚本已加载'); 
// 弹窗欢迎语
alert('欢迎访问我的个人简历');

/*--时钟--*/
window.onload = function () {
    console.log("欢迎访问我的个人简历页面！页面加载完成时间：" + getFormatTime());
    console.log("交互脚本 js/script.js 已加载，正在启动每秒刷新的实时时钟。");

    updateClock();                  
    setInterval(updateClock, 1000); 
};

function getFormatTime() {
    const now = new Date();                                     // 当前时间对象
    const year = now.getFullYear();                             // 年
    const month = String(now.getMonth() + 1).padStart(2, "0");  // 月：getMonth() 从 0 开始计数，所以要 +1
    const day = String(now.getDate()).padStart(2, "0");         // 日
    const hours = String(now.getHours()).padStart(2, "0");      // 时
    const minutes = String(now.getMinutes()).padStart(2, "0");  // 分
    const seconds = String(now.getSeconds()).padStart(2, "0");  // 秒
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

function updateClock() {
    const clock = document.getElementById("clock");
    if (clock) { 
        clock.innerText = getFormatTime();
    }
}


// 主题切换
// 获取按钮节点（js 放在 body 末尾，所以这里能直接拿到）
const themeBtn = document.getElementById("themeBtn");

// 绑定点击事件：onclick 属于 DOM 0 级事件，写法简单、兼容性好
themeBtn.onclick = function () {
    // classList.toggle：切换 body 的 dark 类（有就移除，没有就添加）
    document.body.classList.toggle("dark");

    // classList.contains：判断 body 是否包含 dark 类，据此同步修改按钮文字
    if (document.body.classList.contains("dark")) {
        themeBtn.innerText = "切换亮色主题";
        console.log("已切换到暗色主题，body 的 class 为：" + document.body.className);
    } else {
        themeBtn.innerText = "切换暗色主题";
        console.log("已切换到亮色主题，body 的 class 为：" + document.body.className);
    }
};

/*留言表单前端校验 */

// 正则表达式：只定义一次，避免每次校验都重复创建（test() 用正则去匹配字符串，返回 true / false）
const nameReg = /^[\u4e00-\u9fa5a-zA-Z·\s]{2,20}$/;                                                     // 姓名：2-20 位中文、英文、间隔号或空格
const emailReg = /^[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)*@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)*\.[a-zA-Z]{2,}$/; // 邮箱：标准 xxx@xxx.xx 格式

// 缓存提示区域与三个输入控件，函数内部就不必反复查询 DOM
const formTip = document.getElementById("formTip");
const nameInput = document.getElementById("nameInput");
const emailInput = document.getElementById("emailInput");
const messageInput = document.getElementById("messageInput");

// 统一设置提示信息：type 传 tip-error 显示红色错误，tip-success 显示绿色成功，tip-info 显示蓝色提示
function showTip(text, type) {
    formTip.className = type;   // 切换 class，颜色由 style.css 决定（样式与行为分离）
    formTip.innerText = text;   // 修改提示文字
}

// checkForm：只做校验、绝不提交。失焦（onblur）和提交按钮都会调用它
function checkForm() {
    // 取值并去掉首尾空格：防止用户用空格绕过“非空”校验
    const nameVal = nameInput.value.trim();
    const emailVal = emailInput.value.trim();
    const messageVal = messageInput.value.trim();

    // 1. 姓名判空
    if (nameVal === "") {
        showTip("错误：姓名不能为空！", "tip-error");
        console.log("校验失败：姓名为空。");
        return false;
    }
    // 2. 姓名正则格式校验（2-20 字符，仅中英文/·/空格，禁止数字）
    if (!nameReg.test(nameVal)) {
        showTip("错误：姓名仅支持中英文，不能包含数字，长度 2-20 字符", "tip-error");
        console.log("校验失败：姓名格式不符合要求 → " + nameVal);
        return false;
    }
    // 3. 邮箱判空
    if (emailVal === "") {
        showTip("错误：邮箱不能为空！", "tip-error");
        console.log("校验失败：邮箱为空。");
        return false;
    }
    // 4. 邮箱正则格式校验
    if (!emailReg.test(emailVal)) {
        showTip("错误：邮箱格式不正确，正确格式如 zhangsan@example.com", "tip-error");
        console.log("校验失败：邮箱格式不符合要求 → " + emailVal);
        return false;
    }
    // 5. 留言判空
    if (messageVal === "") {
        showTip("错误：留言内容不能为空！", "tip-error");
        console.log("校验失败：留言内容为空。");
        return false;
    }
    // 6. 留言长度校验（5-500 字符）
    if (messageVal.length < 5 || messageVal.length > 500) {
        showTip("错误：留言长度需要在 5-500 字符之间，当前 " + messageVal.length + " 字符", "tip-error");
        console.log("校验失败：留言长度为 " + messageVal.length + " 字符。");
        return false;
    }
    // 7. 全部校验通过
    showTip("校验成功！", "tip-success");
    console.log("校验通过：三个字段全部合法。");
    return true;
}

// checkSubmit：按钮点击触发，先全量校验，再确认弹窗，最后才提交
function checkSubmit() {
    const flag = checkForm();       // 先跑一遍完整校验
    if (!flag) {
        return false;               // 校验失败：直接结束，绝不提交
    }

    // confirm：浏览器确认框，用户点“确定”返回 true，点“取消”返回 false
    const send = confirm("是否要提交留言？");
    if (send) {
        console.log("用户已确认提交，准备向后端发送数据。");
        showTip("校验通过，正在提交……", "tip-success");
        // 通过表单的 name 拿到表单对象并提交（实验二没有后端，提交后页面会刷新，属正常现象）
        document.contactForm.submit();
    } else {
        showTip("已取消提交，可以在表单里继续修改。", "tip-info");
        console.log("用户取消了提交。");
    }
}

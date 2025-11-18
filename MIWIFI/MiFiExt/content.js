
// 处理导入数据
function processImport(text) {
	if (!text.trim()) return alert('请输入数据后再导入')

	const lines = text.trim().split('\n')
	const devices = []
	const invalids = []
	const ipRegex = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/
	const macRegex = /^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/
	const prefix = document.getElementsByName('ip')[0].value.split('.').slice(0, 3).join('.') + '.'

	lines.forEach((line, index) => {
		const text = line.trim()
		if (!text) return

		const parts = text.split(/\s+/).map(part => part.trim())
		if (parts.length >= 3) {
			const [addr, mac, name] = parts
			const ip = addr.includes('.') ? addr : prefix + addr
			if (ipRegex.test(ip) && macRegex.test(mac)) {
				devices.push({ ip, mac, name })
			} else {
				invalids.push(`第${index + 1}行: 格式不正确`)
			}
		} else {
			invalids.push(`第${index + 1}行: 字段数量不足`)
		}
	})

	if (invalids.length > 0) {
		alert(`错误:\n${invalids.join('\n')}`)
	} else {
		bindDevices(devices)
	}
}

// 发送添加请求
function bindDevices(devices) {
	const xhr = new XMLHttpRequest()
	xhr.open('POST', '/cgi-bin/luci/;stok=' + location.pathname.substring(20, 52) + '/api/xqnetwork/mac_bind')
	xhr.onload = () => {
		if (xhr.status >= 200 && xhr.status < 300) {
			const rsp = JSON.parse(xhr.responseText)
			rsp.code == 0 ? location.reload(1) : alert(rsp.msg)
		} else {
			alert('请求失败: ' + xhr.status)
		}
	}
	xhr.onerror = () => alert('网络错误，请稍后重试')
	xhr.send(new URLSearchParams({ 'data': JSON.stringify(devices) }))
}

// 创建导入对话框
function addBatch() {
	const overlay = document.createElement('div')
	overlay.style.cssText = `
		position: fixed; top: 0; left: 0; width: 100%; height: 100%;
		background-color: rgba(0, 0, 0, 0.7); z-index: 2147483647;
		display: flex; justify-content: center; align-items: center;
		backdrop-filter: blur(3px); pointer-events: auto; overflow: hidden;
	`

	document.body.style.overflow = 'hidden'

	const dialog = document.createElement('div')
	const dialogWidth = Math.min(window.innerWidth * 0.7, 800)
	const dialogHeight = Math.min(window.innerHeight * 0.7, 600)

	dialog.style.cssText = `
		background-color: white; padding: 20px; border-radius: 8px;
		width: ${dialogWidth}px; height: ${dialogHeight}px;
		display: flex; flex-direction: column;
		box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
		z-index: 2147483648; position: relative;
	`

	const title = document.createElement('h2')
	title.textContent = '批量导入设备'
	title.style.marginTop = '0'

	const textareaLabel = document.createElement('label')
	textareaLabel.textContent = '每行一个，空格分隔（如IP地址 MAC地址 设备名称）：'
	textareaLabel.style.cssText = 'display: block; margin-bottom: 10px;'

	const textarea = document.createElement('textarea')
	textarea.style.cssText = `
		flex: 1; padding: 10px; border: 1px solid #ddd;
		border-radius: 4px; font-family: monospace;
		font-size: 14px; resize: none;
	`
	textarea.placeholder = '1 00:11:22:33:44:55 设备1\n2 AA:BB:CC:DD:EE:FF 设备2\n'

	const dialogButtons = document.createElement('div')
	dialogButtons.style.cssText = 'display: flex; justify-content: flex-end; gap: 10px; margin-top: 15px;'

	function closeDialog() {
		if (document.body.contains(overlay)) {
			document.body.removeChild(overlay)
		}
		document.body.style.overflow = ''
	}

	const cancelButton = document.createElement('button')
	cancelButton.textContent = '取消'
	cancelButton.style.cssText = 'padding: 10px 20px; background-color: #f1f1f1; border: none; border-radius: 4px; cursor: pointer;'
	cancelButton.addEventListener('click', closeDialog)

	const confirmButton = document.createElement('button')
	confirmButton.textContent = '导入'
	confirmButton.style.cssText = 'padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer;'
	confirmButton.addEventListener('click', () => processImport(textarea.value))

	overlay.addEventListener('click', e => e.target === overlay && closeDialog())
	dialog.addEventListener('click', e => e.stopPropagation())
	overlay.addEventListener('keydown', e => {
		if (e.key === 'Escape') closeDialog()
		e.stopPropagation()
	})

	dialogButtons.appendChild(cancelButton)
	dialogButtons.appendChild(confirmButton)
	dialog.appendChild(title)
	dialog.appendChild(textareaLabel)
	dialog.appendChild(textarea)
	dialog.appendChild(dialogButtons)
	overlay.appendChild(dialog)
	document.body.appendChild(overlay)

	textarea.focus()
}

function selectAll() {
	let display = false
	const checkboxes = document.querySelectorAll('input[type="checkbox"]')
	checkboxes.forEach(checkbox => {
		checkbox.checked = !checkbox.checked
		if (!display && checkbox.checked) display = true
	})
	document.getElementById('dellist').style.display = display ? '' : 'none'
}

function compareAddr(ip1, ip2) {
	const nums1 = ip1.split('.').map(Number)
	const nums2 = ip2.split('.').map(Number)
	const maxLength = Math.max(nums1.length, nums2.length)

	for (let i = 0; i < maxLength; i++) {
		const num1 = nums1[i] || 0
		const num2 = nums2[i] || 0
		if (num1 < num2) return -1
		if (num1 > num2) return 1
	}
	return 0
}

function ipToInt(ip) {
	return ip.split('.').reduce((result, octet, index) => {
		return result + (parseInt(octet) << ((3 - index) * 8));
	}, 0);
}

function tmToSec(tm) {
	const units = { '天': 86400, '小时': 3600, '分': 60, '秒': 1 }
	let seconds = 0
	let match
	const regex = /(\d+)(天|小时|分|秒)/g
	while ((match = regex.exec(tm))) {
		seconds += parseInt(match[1]) * units[match[2]]
	}
	return seconds
}

var sortRevs = [0, 0, 0, 0, 2, 2, 2, 2, 2]
function sortTable(tbody, id) {
	const idx = parseInt(sortRevs[id] / 2) % 4
	const rows = Array.from(tbody.querySelectorAll('tr'))
	rows.sort((row1, row2) => {
		const getEl = (row) => id < 4 ? row.cells[id] : (idx < 3 ? row.querySelectorAll('.v')[idx] : row.querySelector('.name'))
		let [t1, t2] = [getEl(row1), getEl(row2)].map(el => el?.textContent.trim() || '')
		if (sortRevs[id] % 2) [t1, t2] = [t2, t1]
		if (id == 2 || (id >= 4 && idx == 1)) {
		  return ipToInt(t1) - ipToInt(t2)
		} else if (id >= 4 && idx == 0) {
		  return tmToSec(t1) - tmToSec(t2)
		}
		return t1.localeCompare(t2)
	})
	sortRevs[id]++
	tbody.textContent = ''
	rows.forEach(row => tbody.appendChild(row))
}

function uncomment(el) {
	const it = document.createNodeIterator(el, NodeFilter.SHOW_COMMENT)
	for (let node; node = it.nextNode();) {
		const content = node.nodeValue.trim()
		if (!content || !node.parentNode) continue
		const div = document.createElement('div')
		div.innerHTML = content
		const parent = node.parentNode
		const nextSibling = node.nextSibling
		parent.removeChild(node)
		while (div.firstChild) {
			parent.insertBefore(div.firstChild, nextSibling)
		}
	}
}

function lannetset(list) {
	const addlist = document.getElementById('addlist')
	if (!addlist) return console.log('未找到静态 DHCP 添加按钮')

	// 批量添加按钮
	const addbatch = addlist.cloneNode(true)
	addbatch.id = 'addbatch'
	addbatch.firstChild.innerText = '批量添加'
	addbatch.onclick = addBatch
	addlist.parentElement.appendChild(addbatch)

	// 修改表头
	const ths = list.parentElement.children[0].children[0].children
	ths[0].style.textAlign = 'center'
	ths[0].textContent = '✅'
	ths[0].onclick = selectAll

	for (let i = 1; i <= 3; i++) {
		ths[i].style.color = 'green'
		ths[i].onclick = () => sortTable(list, i)
	}
	sortTable(list, 2)
	return true
}

function devices(list) {
	const tables = list.children
	if (!tables) return console.log('未找到设备表格')

	document.querySelectorAll('.devnetinfo').forEach(uncomment)
	for (let i = 0; i < tables.length; i++) {
		const chs = tables[i].children
		if (chs.length > 1 && chs[1].children.length > 1) {
			const th = chs[0].children[0].children[0]
			th.style.color = 'green'
			th.onclick = () => sortTable(chs[1], 4 + i)
			sortTable(chs[1], 4 + i)
		}
	}

	return true
}

// 初始化逻辑
console.log('小米路由器增强功能已加载')
let is_lannetset = location.pathname.includes('/web/setting/lannetset')
const list = document.getElementById(is_lannetset ? 'bandlist' : 'devicesTables')
if (list) {
	const observer = new MutationObserver(mutations => {
		mutations.forEach(mutation => {
			if (mutation.addedNodes.length > 0 && (is_lannetset ? lannetset(list) : devices(list))) {
				observer.disconnect()
			}
		})
	})
	observer.observe(list, { childList: true })
} else {
	console.log('未找到设备列表')
}
